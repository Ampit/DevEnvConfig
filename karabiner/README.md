# Keyboard shortcuts and Universal Control

Karabiner recognizes the key sequence. Command actions become reserved key combinations, which Universal Control forwards to the focused Mac. Hammerspoon receives the combination and performs the action there. SSH is used for setup only.

## Files

| File | Role |
| --- | --- |
| `rules.ts`, `utils.ts` | Shortcut sequences and actions |
| `command-routing.ts` | Explicit command-to-key registry and generator transformation |
| `karabiner.json` | Generated Karabiner configuration |
| `command-receiver.json` | Generated Hammerspoon command dictionary |
| `../hammerspoon/init.lua` | Loads the receiver and enables launch at login |
| `../hammerspoon/command_receiver.lua` | Registers receiver hotkeys and executes commands |
| `../hammerspoon/directional_focus.lua` | Directional window focus and edge wrapping |

Both JSON files are committed. Edit the TypeScript sources and generate both JSON files together. Do not edit generated files directly. The current generator writes the whole Default profile, including the ANSI keyboard setting; review device/profile differences before rebuilding on another machine.

## Set up a Mac

Clone this repository at `~/.config`. Install Karabiner-Elements, Hammerspoon, Node.js and Yarn. Apps and Raycast extensions used by shortcuts must also be installed on that Mac.

```sh
cd ~/.config/karabiner
yarn install --frozen-lockfile
yarn build
python3 ../hammerspoon/install.py
python3 ../hammerspoon/install.py --check
open -a Hammerspoon
```

Enable Hammerspoon in System Settings > Privacy & Security > Accessibility. Then reload its configuration from the menu bar. The installer links only the three Lua files into `~/.hammerspoon`; it preserves replaced files under `~/.hammerspoon/backups/`. Repeated runs leave correct links alone. Logs and other Hammerspoon runtime files stay outside this repository.

## Shortcuts

Hold Caps Lock to use the existing Hyper layers. Option + Shift + H/J/K/L focuses left/down/up/right across the current visible desktops. Navigation wraps at the edges without moving windows. Minimized, hidden and fully covered windows are excluded.

The 62 command actions use the receiver. Existing ordinary keystrokes, mouse and media outputs remain unchanged.

## Update both Macs

Keep the command/key registry identical on both Macs: different dictionaries can dispatch the wrong action. Add new commands to `command-routing.ts` when adding definitions in `rules.ts` or `utils.ts`. The build rejects unmapped commands and unused registry entries.

Commit once, push once, then update the other checkout to the same commit. Back up and reconcile any dirty files before pulling. Run `yarn build`, verify the generated diff, and reload Hammerspoon on each Mac after receiver changes. Git does not grant Accessibility or Automation permissions.

## Verification and rollback

The reserved-key probe followed focus in both keyboard-host directions. Physical Universal Control tests passed for app launching, Rectangle placement, directional focus and Raycast emoji picker. Every action was not executed individually; app availability and permissions remain machine-specific. Synthetic key injection did not provide a valid receiver test.

The September 10 migration backups are local under `uc-command-backup-20260910/`. Restoring that backup's Karabiner files and Hammerspoon `init.lua`, then reloading Hammerspoon, returns to local command execution. Account for later edits before restoring old files.
