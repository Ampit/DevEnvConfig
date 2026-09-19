#!/usr/bin/env python3
"""Link the tracked Hammerspoon files without discarding existing configuration."""
import argparse
from datetime import datetime
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check', action='store_true', help='verify links without changing files')
args = parser.parse_args()
source = Path(__file__).resolve().parent
runtime = Path.home() / '.hammerspoon'
names = ['init.lua', 'command_receiver.lua', 'directional_focus.lua', 'pointer_navigation.lua']
pending = []
for name in names:
    src, dst = source / name, runtime / name
    if not src.is_file():
        parser.error(f'Missing tracked file: {src}')
    if dst.is_symlink() and dst.resolve() == src:
        continue
    if dst.is_dir():
        parser.error(f'Refusing to replace directory: {dst}')
    pending.append((src, dst))
if args.check:
    for src, dst in pending:
        print(f'Link needed: {dst} -> {src}')
    if pending:
        raise SystemExit(1)
    print('All Hammerspoon links are correct.')
    raise SystemExit(0)
if not pending:
    print('All Hammerspoon links are already correct.')
    raise SystemExit(0)
runtime.mkdir(parents=True, exist_ok=True)
backup = runtime / 'backups' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
for src, dst in pending:
    if dst.exists() or dst.is_symlink():
        backup.mkdir(parents=True, exist_ok=True)
        dst.rename(backup / dst.name)
    dst.symlink_to(src)
    print(f'Linked: {dst} -> {src}')
if backup.exists():
    print(f'Previous files preserved in: {backup}')
print('Reload Hammerspoon to load the linked configuration.')
