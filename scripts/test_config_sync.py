import importlib.util
import json
import subprocess
import tempfile
import types
import unittest
from pathlib import Path
from unittest.mock import patch

spec=importlib.util.spec_from_file_location('sync', Path(__file__).with_name('config_sync.py'))
sync=importlib.util.module_from_spec(spec);spec.loader.exec_module(sync)

class SyncSafety(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory(); self.addCleanup(self.temp.cleanup)
        self.home=Path(self.temp.name)/'home'; self.home.mkdir()
    def test_local_edit_is_preserved(self):
        p=self.home/'.config/nvim/init.lua';p.parent.mkdir(parents=True);p.write_bytes(b'unsaved-user-work')
        with self.assertRaisesRegex(RuntimeError,'Local configuration changed'):
            sync.changes(self.home,{'.config/nvim/init.lua':b'new'}, {'.config/nvim/init.lua':sync.digest(b'old')})
        self.assertEqual(p.read_bytes(),b'unsaved-user-work')
    def test_unknown_existing_file_requires_bootstrap(self):
        (self.home/'.zshrc').write_bytes(b'private')
        with self.assertRaises(RuntimeError):sync.changes(self.home,{'.zshrc':b'new'}, {})
    def test_removed_managed_file_must_be_unchanged(self):
        (self.home/'old').write_bytes(b'old')
        self.assertEqual(sync.changes(self.home,{}, {'old':sync.digest(b'old')}), {'old':(b'old',None)})
        (self.home/'old').write_bytes(b'edit')
        with self.assertRaises(RuntimeError):sync.changes(self.home,{}, {'old':sync.digest(b'old')})
    def test_symlink_parent_rejected(self):
        other=Path(self.temp.name)/'outside';other.mkdir();(self.home/'.config').symlink_to(other)
        with self.assertRaisesRegex(RuntimeError,'Symlink'):sync.target(self.home,'.config/nvim/init.lua')
    def test_path_traversal_rejected(self):
        for name in ['../outside','/etc/passwd']:
            with self.assertRaises(RuntimeError):sync.target(self.home,name)
    def test_failed_plugin_restore_rolls_back_files(self):
        (self.home/'old').write_bytes(b'before')
        with patch.object(sync,'restore_plugins',side_effect=[RuntimeError('restore failed'),None]):
            with self.assertRaisesRegex(RuntimeError,'restore failed'):
                sync.apply_files(self.home,{'old':(b'before',b'after'),'new':(None,b'new')},self.home/'backups/one',True)
        self.assertEqual((self.home/'old').read_bytes(),b'before');self.assertFalse((self.home/'new').exists())
        self.assertEqual((self.home/'backups/one/old').stat().st_mode & 0o777,0o600)
    def test_active_apps_defer_without_touching_config(self):
        repo=Path(self.temp.name)/'repo';repo.mkdir()
        for args in [('init','-b','main'),('config','user.name','Test'),('config','user.email','test@example.test')]:sync.git(repo,*args)
        (repo/'nvim').mkdir();(repo/'nvim/init.lua').write_text('-- proposed')
        sync.git(repo,'add','.');sync.git(repo,'commit','-m','fixture')
        p=self.home/'.config/nvim/init.lua';p.parent.mkdir(parents=True);p.write_text('-- current')
        with patch.object(sync,'busy',return_value=['nvim']):
            result=sync.synchronize(repo,self.home,'devbox',bootstrap=True,fetch=False)
        self.assertEqual(result['state'],'pending');self.assertEqual(p.read_text(),'-- current')
    def test_allowlist_excludes_credentials_and_mac_automation(self):
        repo=Path(self.temp.name)/'repo';repo.mkdir()
        for name in ['nvim/init.lua','gh/hosts.yml','linux/zshrc','karabiner/karabiner.json']:
            p=repo/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text('fixture')
        with patch.object(sync,'git',return_value='nvim/init.lua\ngh/hosts.yml\nlinux/zshrc\nkarabiner/karabiner.json'):
            data=sync.desired_linux(repo)
        self.assertEqual(set(data),{'.config/nvim/init.lua','.zshrc'})


class AgentGuidanceSafety(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / 'home'
        self.home.mkdir()
        self.repo = Path(self.temp.name) / 'repo'
        self.repo.mkdir()
        for args in [('init', '-b', 'main'), ('config', 'user.name', 'Test'),
                     ('config', 'user.email', 'test@example.test')]:
            sync.git(self.repo, *args)
        for name, text in {'agents/workflow.md': '# Workflow\nKeep scope and approval boundaries.\n',
                           'agents/hosts/devbox.md': 'Local records: {{HOME}}/.local/state/agent-workflow\n',
                           'agents/hosts/macos.md': 'Read Devbox records through SSH; Fleet: {{HOME}}/workspace/fleet\n',
                           'nvim/init.lua': '-- fixture\n'}.items():
            p = self.repo / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(text)
        sync.git(self.repo, 'add', '.')
        sync.git(self.repo, 'commit', '-m', 'fixture')

    def desired(self, host='devbox'):
        return sync.desired_agent_rules(self.repo, self.home, host)

    def test_host_rendering_and_allowlist(self):
        linux = self.desired()
        mac = self.desired('work-mac')
        self.assertEqual(set(linux), {'AGENTS.md', '.codex/AGENTS.md', '.claude/CLAUDE.md', '.gemini/GEMINI.md'})
        self.assertEqual(len(set(linux.values())), 1)
        self.assertIn(str(self.home).encode(), linux['AGENTS.md'])
        self.assertNotIn(b'{{HOME}}', linux['AGENTS.md'])
        self.assertIn(b'through SSH', mac['AGENTS.md'])
        self.assertEqual(mac, self.desired('personal-mac'))
        self.assertNotIn('access-map.md', linux)

    def test_unknown_host_and_active_override_stop(self):
        with self.assertRaisesRegex(RuntimeError, 'Unknown guidance host'):
            self.desired('unrecognized')
        p = self.home / '.codex/AGENTS.override.md'
        p.parent.mkdir()
        p.write_text('user override')
        with self.assertRaisesRegex(RuntimeError, 'override is active'):
            self.desired()
        self.assertEqual(p.read_text(), 'user override')

    def test_empty_or_symlinked_source_is_rejected(self):
        p = self.repo / 'agents/workflow.md'
        p.write_text('')
        with self.assertRaisesRegex(RuntimeError, 'Empty guidance'):
            self.desired()
        p.unlink()
        p.symlink_to(self.repo / 'nvim/init.lua')
        with self.assertRaisesRegex(RuntimeError, 'regular file'):
            self.desired()

    def test_existing_custom_global_file_is_not_adopted_or_overwritten(self):
        p = self.home / '.codex/AGENTS.md'
        p.parent.mkdir()
        p.write_text('private customization')
        report = {}
        with self.assertRaisesRegex(RuntimeError, 'Local configuration changed'):
            sync.synchronize_agent_rules(self.repo, self.home, 'devbox', {}, report,
                                         self.home / 'state', 'revision')
        self.assertEqual(p.read_text(), 'private customization')
        self.assertFalse((self.home / 'AGENTS.md').exists())

    def test_render_apply_idempotence_and_drift_preservation(self):
        state = self.home / 'state'
        first = {}
        sync.synchronize_agent_rules(self.repo, self.home, 'devbox', {}, first, state, 'one')
        self.assertEqual(first['agent_updated_files'], 4)
        self.assertEqual(len(first['agent_managed']), 4)
        second = {}
        sync.synchronize_agent_rules(self.repo, self.home, 'devbox', first, second, state, 'one')
        self.assertEqual(second['agent_updated_files'], 0)
        customized = self.home / '.claude/CLAUDE.md'
        customized.write_text('keep this edit')
        old_codex = (self.home / '.codex/AGENTS.md').read_bytes()
        (self.repo / 'agents/workflow.md').write_text('# Changed source\n')
        with self.assertRaisesRegex(RuntimeError, 'Local configuration changed'):
            sync.synchronize_agent_rules(self.repo, self.home, 'devbox', first, {}, state, 'two')
        self.assertEqual(customized.read_text(), 'keep this edit')
        self.assertEqual((self.home / '.codex/AGENTS.md').read_bytes(), old_codex)

    def test_regular_sync_updates_mac_guidance_without_neovim_work(self):
        first = sync.synchronize(self.repo, self.home, 'work-mac', fetch=False)
        self.assertEqual(first['state'], 'current')
        original = sync.git(self.repo, 'rev-parse', 'HEAD')
        sync.git(self.repo, 'checkout', '-b', 'incoming')
        (self.repo / 'agents/workflow.md').write_text('# Updated workflow\nKeep approved scope.\n')
        sync.git(self.repo, 'add', 'agents/workflow.md')
        sync.git(self.repo, 'commit', '-m', 'guidance update')
        desired = sync.git(self.repo, 'rev-parse', 'HEAD')
        sync.git(self.repo, 'update-ref', 'refs/remotes/devbox-config/main', desired)
        sync.git(self.repo, 'checkout', 'main')
        self.assertEqual(sync.git(self.repo, 'rev-parse', 'HEAD'), original)
        original_git = sync.git
        def git_without_network(repo, *args):
            return '' if args[0] == 'fetch' else original_git(repo, *args)
        ctl = types.SimpleNamespace(tracked_local=lambda: [], local_path=lambda p: False,
                                    preflight=unittest.mock.Mock(side_effect=AssertionError('Unrelated Neovim check')))
        with patch.object(sync, 'git', side_effect=git_without_network), \
                patch.object(sync, 'busy', return_value=[]), patch.dict('sys.modules', {'configctl': ctl}):
            result = sync.synchronize(self.repo, self.home, 'work-mac')
        self.assertEqual(result['state'], 'current', result)
        self.assertEqual(result['agent_applied_commit'], desired)
        self.assertEqual(result['agent_updated_files'], 4)
        self.assertIn('Updated workflow', (self.home / '.gemini/GEMINI.md').read_text())
        ctl.preflight.assert_not_called()

    def test_linux_and_mac_share_the_same_guidance_apply_path(self):
        with patch.object(sync, 'validate'), patch.object(sync, 'busy', return_value=[]):
            result = sync.synchronize(self.repo, self.home, 'devbox', bootstrap=True, fetch=False)
        self.assertEqual(result['state'], 'current', result)
        self.assertEqual(result['agent_updated_files'], 4)
        self.assertEqual((self.home / 'AGENTS.md').read_bytes(), self.desired()['AGENTS.md'])

if __name__=='__main__': unittest.main()
