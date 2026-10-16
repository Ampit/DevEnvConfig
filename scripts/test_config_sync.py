import importlib.util
import json
import subprocess
import tempfile
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

if __name__=='__main__': unittest.main()
