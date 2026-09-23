#!/usr/bin/env python3
"""Manage shared config without synchronizing machine-local app state."""
import argparse
import datetime
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOCAL = ('1Password/', 'Questrade/', 'mole/', 'zed/', 'firebase/', 'herdr/', 'gitid/', 'gh/hosts.yml', 'karabiner/automatic_backups/',
         'ghostty/config.before-', 'local/')
COMPONENTS = ('keyboard', 'neovim', 'terminal', 'other')


def git(*args):
    return subprocess.check_output(['git', '-C', str(ROOT), *args], text=True).strip()


def local_path(name):
    return any(name.startswith(prefix) if prefix.endswith(('/', '-')) else name == prefix
               for prefix in LOCAL)


def component(name):
    if name.startswith(('karabiner/', 'hammerspoon/')):
        return 'keyboard'
    if name.startswith('nvim/'):
        return 'neovim'
    if name.startswith(('ghostty/', 'zsh/', 'tmux/', 'starship', 'lazygit/')):
        return 'terminal'
    return 'other'


def tracked_local():
    return [p for p in git('ls-files').splitlines() if local_path(p)]


def protect_local():
    paths = tracked_local()
    if not paths:
        print('Machine-local files are already outside Git tracking.')
        return
    # Keep a second copy outside the checkout before changing the index.
    backup = Path.home() / '.local/state/mac-config/backups' / datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True, mode=0o700)
    hashes = {}
    for name in paths:
        src = ROOT / name
        if src.is_file():
            dest = backup / name
            dest.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
            shutil.copy2(src, dest)
            dest.chmod(0o600)
            hashes[name] = hashlib.sha256(src.read_bytes()).hexdigest()
    subprocess.run(['git', '-C', str(ROOT), 'rm', '--cached', '--quiet', '--', *paths], check=True)
    for name, digest in hashes.items():
        if hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest:
            raise RuntimeError('Local file changed during migration: ' + name)
    print(f'Stopped tracking {len(paths)} local files; on-disk files preserved.')
    print('Recovery copy:', backup)


def preflight(components):
    needed = {'keyboard': ['yarn', 'hs'], 'neovim': ['nvim']}
    for name in components:
        for executable in needed.get(name, []):
            if not shutil.which(executable):
                raise RuntimeError('Missing required tool: ' + executable)
    if 'neovim' in components:
        policy = json.loads((ROOT / 'config-policy.json').read_text())
        version = subprocess.check_output(['nvim', '--version'], text=True).splitlines()[0]
        if not version.startswith('NVIM v' + policy['neovim_series'] + '.'):
            raise RuntimeError('Neovim version mismatch: ' + version + '. Shared config expects ' + policy['neovim_series'] + '.x; align the app first.')


def apply(components):
    preflight(components)
    if 'keyboard' in components:
        subprocess.run(['yarn', '--cwd', str(ROOT / 'karabiner'), 'build'], check=True)
        subprocess.run([sys.executable, str(ROOT / 'hammerspoon/install.py')], check=True)
        result = subprocess.run(['hs', '-c', 'hs.reload()'], capture_output=True, text=True)
        if result.returncode not in (0, 69):
            raise RuntimeError('Hammerspoon reload failed: ' + result.stderr)
        # Reload invalidates IPC; a fresh invocation verifies initialization.
        import time
        for attempt in range(5):
            result = subprocess.run(['hs', '-c', 'assert(hyperGuide and commandReceiver and pointerNavigation); print("Keyboard helpers loaded")'], capture_output=True, text=True)
            if result.returncode == 0:
                print(result.stdout.strip())
                break
            time.sleep(0.5)
        else:
            raise RuntimeError('Hammerspoon did not initialize after reload.')
    if 'neovim' in components:
        lock = ROOT / 'nvim/lazy-lock.json'
        before = lock.read_bytes()
        subprocess.run(['nvim', '--headless', '+Lazy! restore', '+qa'], check=True)
        if lock.read_bytes() != before:
            raise RuntimeError('Plugin restore unexpectedly changed lazy-lock.json; inspect before committing.')
        print('Neovim plugins restored to the shared lockfile. Neovim itself was not upgraded.')
    if 'terminal' in components:
        print('Terminal files are in place. Reload the relevant app or open a new shell.')
    if 'other' in components:
        print('Other shared files are in place. App-specific reloads may be needed.')


def plan():
    git('fetch', 'origin')
    git('merge-base', '--is-ancestor', 'HEAD', '@{upstream}')
    paths = git('diff', '--name-only', 'HEAD', '@{upstream}').splitlines()
    for name in paths:
        print(f'{component(name):9} {name}')
    if not paths:
        print('No incoming changes.')
    return paths


def update(components):
    if git('status', '--porcelain'):
        raise RuntimeError('Checkout has local changes. Review and commit or stash them yourself; nothing was pulled.')
    if tracked_local():
        raise RuntimeError('Machine-local files are still tracked. Complete protect-local migration before updating.')
    paths = plan()
    blocked = {component(p) for p in paths} - set(components)
    if blocked:
        raise RuntimeError('Incoming changes also affect: ' + ', '.join(sorted(blocked)) + '. Include these components or postpone the update. Nothing was pulled.')
    if any(local_path(p) for p in paths):
        raise RuntimeError('Incoming commit changes machine-local paths; inspect it manually. Nothing was pulled.')
    preflight(components)
    # Inspect incoming policy before a pull can replace active Neovim config.
    if 'neovim' in components:
        incoming = json.loads(git('show', '@{upstream}:config-policy.json'))
        version = subprocess.check_output(['nvim', '--version'], text=True).splitlines()[0]
        if not version.startswith('NVIM v' + incoming['neovim_series'] + '.'):
            raise RuntimeError('Incoming config requires Neovim ' + incoming['neovim_series'] + '.x. Nothing was pulled.')
    git('merge', '--ff-only', '@{upstream}')
    apply(components)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('status')
    sub.add_parser('plan')
    sub.add_parser('protect-local')
    for action in ('apply', 'update'):
        p = sub.add_parser(action)
        p.add_argument('components', choices=COMPONENTS, nargs='+')
    args = parser.parse_args()
    if args.action == 'status':
        print('Repository:', ROOT)
        print('Commit:', git('rev-parse', '--short', 'HEAD'))
        print(git('status', '--short') or 'Shared checkout clean.')
        print('Still-tracked local files:', len(tracked_local()))
        for name in COMPONENTS:
            try:
                preflight([name])
                print(name + ': prerequisites OK')
            except RuntimeError as error:
                print(name + ': ' + str(error))
    elif args.action == 'plan':
        plan()
    elif args.action == 'protect-local':
        protect_local()
    elif args.action == 'apply':
        apply(args.components)
    elif args.action == 'update':
        update(args.components)


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, subprocess.CalledProcessError) as error:
        sys.exit(str(error))
