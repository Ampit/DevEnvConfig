from pathlib import Path
import copy
import json
import shutil
import subprocess
import sys
import tempfile
import unittest

SOURCE = Path(__file__).resolve().parent


def generate(root, settings=None):
    target = root / 'karabiner'
    target.mkdir()
    for pattern in ('*.ts', 'hyper-guide.py'):
        for source in SOURCE.glob(pattern):
            shutil.copy2(source, target / source.name)
    (target / 'node_modules').symlink_to(SOURCE / 'node_modules', target_is_directory=True)
    if settings is not None:
        (root / 'local').mkdir()
        (root / 'local/keyboard.json').write_text(json.dumps(settings))
    subprocess.run([str(target / 'node_modules/.bin/tsm'), 'rules.ts'], cwd=target,
                   check=True, capture_output=True)
    result = subprocess.run([sys.executable, 'hyper-guide.py'], cwd=target,
                            capture_output=True, text=True)
    return result, target


def oh_shortcut(manipulator):
    return manipulator.get('from', {}).get('key_code') == 'h' and any(
        condition.get('name') == 'hyper_sublayer_o' and condition.get('value') == 1
        for condition in manipulator.get('conditions', [])
    )


class LocalKeyboardTest(unittest.TestCase):
    def test_work_removal_preserves_every_other_mapping_and_shared_receiver(self):
        with tempfile.TemporaryDirectory() as personal, tempfile.TemporaryDirectory() as work:
            personal_result, personal_dir = generate(Path(personal))
            work_result, work_dir = generate(Path(work), {'remove': [['o', 'h']]})
            self.assertEqual(personal_result.returncode, 0, personal_result.stderr)
            self.assertEqual(work_result.returncode, 0, work_result.stderr)
            personal_config = json.loads((personal_dir / 'karabiner.json').read_text())
            work_config = json.loads((work_dir / 'karabiner.json').read_text())
            expected = copy.deepcopy(personal_config)
            removed = 0
            for profile in expected['profiles']:
                for rule in profile['complex_modifications']['rules']:
                    before = rule['manipulators']
                    rule['manipulators'] = [m for m in before if not oh_shortcut(m)]
                    removed += len(before) - len(rule['manipulators'])
            self.assertEqual(removed, 1)
            self.assertEqual(work_config, expected)
            personal_guide = json.loads((personal_dir / 'hyper-guide-menu.json').read_text())
            work_guide = json.loads((work_dir / 'hyper-guide-menu.json').read_text())
            expected_guide = copy.deepcopy(personal_guide)
            self.assertEqual(next(i['app'] for i in personal_guide['o']['items'] if i['key'] == 'h'), 'Google Chrome')
            expected_guide['o']['items'] = [i for i in expected_guide['o']['items'] if i['key'] != 'h']
            self.assertEqual(work_guide, expected_guide)
            self.assertEqual((work_dir / 'command-receiver.json').read_bytes(),
                             (personal_dir / 'command-receiver.json').read_bytes())

    def test_malformed_removal_fails_before_writing_guide(self):
        with tempfile.TemporaryDirectory() as root:
            result, target = generate(Path(root), {'remove': ['o.h']})
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('[layer, key] pairs', result.stderr)
            self.assertFalse((target / 'hyper-guide-menu.json').exists())


if __name__ == '__main__':
    unittest.main()
