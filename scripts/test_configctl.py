import contextlib
import importlib.util
import io
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('configctl', Path(__file__).with_name('configctl.py'))
ctl = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ctl)


class ConfigSafetyTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'repo'
        self.root.mkdir()
        self.patch = patch.object(ctl, 'ROOT', self.root)
        self.patch.start()
        self.addCleanup(self.patch.stop)
        self.run_git('init', '-q')
        self.run_git('config', 'user.name', 'Test')
        self.run_git('config', 'user.email', 'test@example.invalid')

    def run_git(self, *args):
        return subprocess.check_output(['git', '-C', str(self.root), *args], text=True).strip()

    def write(self, path, value):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(value)

    def commit(self):
        self.run_git('add', '.')
        self.run_git('commit', '-qm', 'fixture')

    def test_protect_preserves_modified_local_files_and_sessions(self):
        self.write('herdr/config.toml', 'original')
        self.write('gh/hosts.yml', 'fake-login')
        self.write('nvim/init.lua', '-- shared')
        self.commit()
        self.write('herdr/config.toml', 'local-change')
        self.write('herdr/sessions/one.json', 'local-session')
        home = Path(self.temp.name) / 'home'
        with patch.object(Path, 'home', return_value=home), contextlib.redirect_stdout(io.StringIO()):
            ctl.protect_local()
            ctl.protect_local()
        self.assertEqual((self.root / 'herdr/config.toml').read_text(), 'local-change')
        self.assertEqual((self.root / 'herdr/sessions/one.json').read_text(), 'local-session')
        self.assertEqual(ctl.tracked_local(), [])
        self.assertIn('nvim/init.lua', self.run_git('ls-files'))
        copies = list(home.glob('.local/state/mac-config/backups/*/herdr/config.toml'))
        self.assertEqual(len(copies), 1)
        self.assertEqual(copies[0].read_text(), 'local-change')
        self.assertEqual(copies[0].stat().st_mode & 0o777, 0o600)

    def test_dirty_checkout_blocks_update_before_fetch(self):
        self.write('shared', 'initial')
        self.commit()
        self.write('shared', 'edited')
        with patch.object(ctl, 'plan') as plan:
            with self.assertRaisesRegex(RuntimeError, 'local changes'):
                ctl.update(['keyboard'])
            plan.assert_not_called()

    def test_mixed_update_does_not_move_head(self):
        self.write('karabiner/example', 'initial')
        self.write('nvim/example', 'initial')
        self.commit()
        base = self.run_git('rev-parse', 'HEAD')
        self.run_git('branch', 'incoming')
        self.run_git('checkout', '-q', 'incoming')
        self.write('karabiner/example', 'new')
        self.write('nvim/example', 'new')
        self.commit()
        incoming = self.run_git('rev-parse', 'HEAD')
        self.run_git('checkout', '-q', '-b', 'consumer', base)
        self.run_git('remote', 'add', 'origin', str(self.root))
        self.run_git('fetch', '-q', 'origin')
        self.run_git('branch', '--set-upstream-to=origin/incoming')
        with contextlib.redirect_stdout(io.StringIO()):
            with self.assertRaisesRegex(RuntimeError, 'neovim'):
                ctl.update(['keyboard'])
        self.assertEqual(self.run_git('rev-parse', 'HEAD'), base)
        self.assertNotEqual(base, incoming)
        self.assertEqual((self.root / 'nvim/example').read_text(), 'initial')


if __name__ == '__main__':
    unittest.main()
