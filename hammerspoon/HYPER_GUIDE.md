# Hyper Guide

Hold Caps Lock for 500 ms to see the available shortcuts. Hold a group key such as O, I, or W to see that layer. Before the panel opens, changing layers restarts the delay; once visible, it updates in 20 ms. Release Caps Lock to dismiss.

**Hyper + /** toggles the guide when / is released. A brief message confirms the change. The setting is saved separately on each Mac. App, window, and pointer shortcuts continue to work when the guide is off.

## Configuration

- `karabiner/rules.ts` defines the shortcut layers.
- `karabiner/command-routing.ts` assigns app and window actions to the existing receiver keys.
- `karabiner/hyper-guide.py` adds layer notifications and the toggle after command routing, and generates `hyper-guide-menu.json` from the actual mappings.
- `hammerspoon/hyper_guide.lua` draws the panel and handles its toggle.
- `hammerspoon/init.lua` loads Hyper Guide at startup.

Run `yarn build` in `~/.config/karabiner` after editing shortcuts. Reload Hammerspoon after rebuilding to load the updated menu. No extra global modifier shortcut is registered for the guide. The root-only / mapping is checked for conflicts during generation.

## Universal Control

App and window actions still use the existing receiver routing and follow the focused Mac. Guide notifications use local Hammerspoon URLs: the panel and toggle belong to the Mac hosting the physical keyboard. They do not follow Universal Control to the destination Mac. Both Macs have the same guide so either built-in keyboard can use it locally.

The URL notifications are asynchronous. Actual key timing across devices remains a manual check. The original local trial files are no longer the active installation.
