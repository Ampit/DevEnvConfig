"""Apply published dotfiles conservatively; never publish or discard local edits."""
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def run(args, **kwargs):
    return subprocess.run(args, check=True, capture_output=True, text=True, **kwargs).stdout.strip()


def git(repo, *args):
    return run(['git', '-C', str(repo), *args])


def digest(data):
    return hashlib.sha256(data).hexdigest()


def current(path):
    if path.is_symlink():
        raise RuntimeError('Symlink destination requires manual review: ' + str(path))
    return path.read_bytes() if path.exists() else None


def target(home, name):
    rel = Path(name)
    if rel.is_absolute() or '..' in rel.parts:
        raise RuntimeError('Unsafe configuration destination: ' + name)
    p = home / rel
    for parent in [p, *p.parents]:
        if parent == home:
            break
        if parent.is_symlink():
            raise RuntimeError('Symlink path requires manual review: ' + str(parent))
    return p


def atomic(path, data, mode=0o600):
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, name = tempfile.mkstemp(prefix='.fleet-', dir=path.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(data)
        os.chmod(name, mode)
        os.replace(name, path)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def busy(names):
    lines = run(['ps', '-axo', 'uid=,comm=']).splitlines()
    result = []
    for line in lines:
        fields = line.strip().split(None, 1)
        if len(fields) == 2 and fields[0] == str(os.getuid()):
            name = Path(fields[1]).name.lower()
            if any(n.lower() in name for n in names):
                result.append(name)
    return sorted(set(result))


def affected(names):
    tools = set()
    for name in names:
        if 'nvim/' in name:
            tools.update(['nvim', 'neovide'])
        if 'btop/' in name:
            tools.add('btop')
        if 'lazygit/' in name:
            tools.add('lazygit')
        if name.startswith(('karabiner/', 'hammerspoon/')):
            tools.update(['karabiner', 'hammerspoon'])
    return tools


def desired_linux(repo):
    files = git(repo, 'ls-files').splitlines()
    mapping = {}
    exact = {
        'btop/btop.conf': '.config/btop/btop.conf',
        'starship.toml': '.config/starship.toml',
        'linux/zshrc': '.zshrc',
        'linux/tmux.conf': '.tmux.conf',
        'linux/lazygit.yml': '.config/lazygit/config.yml',
    }
    for name in files:
        if name.startswith(('nvim/', 'btop/themes/')):
            destination = '.config/' + name
        elif name in exact:
            destination = exact[name]
        else:
            continue
        p = repo / name
        if p.is_symlink() or not p.is_file():
            raise RuntimeError('Shared configuration must be a regular file: ' + name)
        mapping[destination] = p.read_bytes()
    if '.config/nvim/init.lua' not in mapping:
        raise RuntimeError('Shared Neovim configuration missing')
    return mapping


def changes(home, desired, previous, bootstrap=False):
    result = {}
    for name in sorted(set(desired) | set(previous)):
        before = current(target(home, name))
        after = desired.get(name)
        if before == after:
            continue
        expected = previous.get(name)
        actual = digest(before) if before is not None else None
        if not bootstrap and ((name in previous and actual != expected) or
                              (name not in previous and before is not None)):
            raise RuntimeError('Local configuration changed; preserved: ' + name)
        result[name] = (before, after)
    return result


def validate(repo, desired):
    policy = json.loads((repo / 'config-policy.json').read_text())
    version = run(['nvim', '--version']).splitlines()[0]
    if not version.startswith('NVIM v' + policy['neovim_series'] + '.'):
        raise RuntimeError('Neovim binary does not match config-policy.json; tool upgrade required')
    for name, data in desired.items():
        if name.endswith('.json') and not name.endswith('.neoconf.json'):
            json.loads(data)
    with tempfile.TemporaryDirectory(prefix='fleet-validate-') as directory:
        root = Path(directory)
        for index, (name, data) in enumerate(desired.items()):
            p = root / str(index)
            p.write_bytes(data)
            if name.endswith('.lua'):
                code = 'assert(loadfile(' + json.dumps(str(p)) + '))'
                checker = root / 'check.lua'
                checker.write_text(code)
                run(['nvim', '--headless', '-u', 'NONE', '-l', str(checker)])
            if name == '.zshrc':
                run(['zsh', '-n', str(p)])


def restore_plugins():
    code = '''local ok, err = pcall(function()
local lockpath=vim.fn.stdpath('config')..'/lazy-lock.json'
local original=vim.fn.readfile(lockpath)
local lock=vim.json.decode(table.concat(original,'\\n'))
require('lazy').restore({wait=true})
for name, pin in pairs(lock) do
 local head=vim.fn.system({'git','-C',vim.fn.stdpath('data')..'/lazy/'..name,'rev-parse','HEAD'}):gsub('%s+$','')
 assert(head==pin.commit,'Plugin revision mismatch: '..name)
end
local registry=package.loaded['mason-registry']
if registry then assert(vim.wait(120000,function()
 for _,pkg in ipairs(registry.get_installed_packages()) do if pkg:is_installing() then return false end end
 return true
end,100),'Mason still installing') end
vim.fn.writefile(original,lockpath)
end)
if not ok then print(err); vim.cmd('cquit 1') else vim.cmd('qa!') end'''
    run(['nvim', '--headless', '-c', 'lua ' + code], timeout=240)


def apply_files(home, batch, backup, plugin_change=False):
    backup.mkdir(parents=True, mode=0o700)
    info = {}
    for name, (before, after) in batch.items():
        p = target(home, name)
        info[name] = {'existed': before is not None, 'mode': p.stat().st_mode & 0o777 if p.exists() else 0o644}
        if before is not None:
            atomic(backup / name, before)
    atomic(backup / 'manifest.json', json.dumps(info, indent=2).encode())
    try:
        for name, (_, data) in batch.items():
            p = target(home, name)
            if data is None:
                p.unlink()
            else:
                atomic(p, data, info[name]['mode'])
        if plugin_change:
            restore_plugins()
    except Exception:
        for name, (before, _) in batch.items():
            p = target(home, name)
            if before is None:
                p.unlink(missing_ok=True)
            else:
                atomic(p, before, info[name]['mode'])
        if plugin_change:
            try:
                restore_plugins()
            except Exception as exc:
                raise RuntimeError('Config restored; plugin rollback needs attention: ' + str(exc))
        raise


def synchronize(repo, home, host, bootstrap=False, fetch=True):
    state = home / '.local/state/fleet/config'
    state.mkdir(parents=True, exist_ok=True, mode=0o700)
    with (state / 'lock').open('w') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return {'state': 'busy'}
        status_path = state / 'status.json'
        old = json.loads(status_path.read_text()) if status_path.exists() else {}
        report = {k: old[k] for k in ['applied_commit', 'managed', 'backup'] if k in old}
        report.update(host=host, checked_at=datetime.datetime.now(datetime.timezone.utc).isoformat())
        try:
            if fetch:
                if host == 'devbox':
                    git(repo, 'fetch', 'origin', 'main')
                    ref = 'origin/main'
                else:
                    git(repo, 'fetch', 'devbox-config', 'refs/remotes/origin/main:refs/remotes/devbox-config/main')
                    ref = 'devbox-config/main'
            else:
                ref = 'HEAD'
            desired_commit = git(repo, 'rev-parse', ref)
            report['desired_commit'] = desired_commit
            if git(repo, 'status', '--porcelain'):
                raise RuntimeError('Shared checkout has local changes; nothing overwritten')
            if git(repo, 'branch', '--show-current') != 'main':
                raise RuntimeError('Shared checkout is not on main; nothing overwritten')
            git(repo, 'merge-base', '--is-ancestor', 'HEAD', ref)
            incoming = git(repo, 'diff', '--name-only', 'HEAD', ref).splitlines()
            if host != 'devbox':
                # A pull changes live Mac config. Never cross this boundary while an affected app runs.
                active = busy(affected(incoming))
                if active:
                    report.update(state='pending', reason='Active apps: ' + ', '.join(active))
                elif incoming:
                    import configctl
                    if configctl.tracked_local() or any(configctl.local_path(p) for p in incoming):
                        raise RuntimeError('Machine-local paths need manual review')
                    if any(p.startswith(('karabiner/', 'hammerspoon/')) for p in incoming):
                        report.update(state='pending', reason='Keyboard changes require explicit configctl update')
                    else:
                        configctl.preflight(['neovim'])
                        incoming_policy = json.loads(git(repo, 'show', ref + ':config-policy.json'))
                        version = run(['nvim', '--version']).splitlines()[0]
                        if not version.startswith('NVIM v' + incoming_policy['neovim_series'] + '.'):
                            raise RuntimeError('Incoming Neovim version policy needs a tool upgrade')
                        backup = state / 'backups' / datetime.datetime.now().strftime('%Y%m%dT%H%M%S%f')
                        backup.mkdir(parents=True, mode=0o700)
                        atomic(backup / 'previous-commit', (git(repo, 'rev-parse', 'HEAD')+'\n').encode())
                        for name in incoming:
                            p = repo / name
                            if p.is_file() and not p.is_symlink():
                                atomic(backup / name, p.read_bytes())
                        git(repo, 'merge', '--ff-only', ref)
                        if 'nvim/lazy-lock.json' in incoming:
                            restore_plugins()
                        report.update(state='current', applied_commit=desired_commit, backup=str(backup), reason='Published configuration applied')
                else:
                    report.update(state='current', applied_commit=desired_commit, reason='No incoming changes')
            else:
                git(repo, 'merge', '--ff-only', ref)
                desired = desired_linux(repo)
                batch = changes(home, desired, old.get('managed', {}), bootstrap)
                active = busy(affected(batch))
                if active:
                    report.update(state='pending', reason='Active apps: ' + ', '.join(active))
                else:
                    if batch:
                        validate(repo, desired)
                        # Recheck drift and processes immediately before mutation.
                        batch = changes(home, desired, old.get('managed', {}), bootstrap)
                        if busy(affected(batch)):
                            raise RuntimeError('An affected app started during validation; retry later')
                        backup = state / 'backups' / datetime.datetime.now().strftime('%Y%m%dT%H%M%S%f')
                        lockname = '.config/nvim/lazy-lock.json'
                        plugin_change = lockname in batch and batch[lockname][0] is not None and json.loads(batch[lockname][0]) != json.loads(batch[lockname][1])
                        apply_files(home, batch, backup, plugin_change)
                        report['backup'] = str(backup)
                    report.update(state='current', applied_commit=desired_commit, managed={p:digest(data) for p,data in desired.items()}, reason=f'{len(batch)} configuration files updated')
        except Exception as exc:
            report.update(state='needs-attention', reason=str(exc))
        atomic(status_path, json.dumps(report, indent=2).encode())
        return report
