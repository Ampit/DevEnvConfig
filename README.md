# DevEnvConfig

One shared repository, with an independent checkout in `~/.config` on each Mac.
Changes reach the other Mac only after a commit, push, and explicit update there.

## What belongs where

| Shared in Git | Local to each Mac, ignored by Git |
| --- | --- |
| Karabiner rules and generated configuration | Entire `herdr/` directory: sessions, preferences, logs, sockets, onboarding |
| Hammerspoon helpers and Hyper Guide | GitHub login file `gh/hosts.yml` and Firebase credentials in `firebase/` |
| Neovim configuration and `nvim/lazy-lock.json` | Git identity profiles and mappings in `gitid/` |
| Terminal configuration and Git ignore rules | Karabiner automatic backups and old Ghostty backup files |
| Configuration management scripts | Optional private files in `local/` |

`local/` holds settings that stay on this Mac. Hammerspoon reads optional
`local/apps.json` on reload. Keys are shared app names without `.app`; values
are `false` to disable that launcher or a replacement app name:

```json
{
  "IntelliJ IDEA OSS": false
}
```

Without an entry, the shared app shortcut works as usual. Disabled launchers do
nothing and are hidden from this Mac's Hyper Guide. Replacement names update both
the launcher and its guide label. Reload Hammerspoon after editing this file.
The internal receiver keys remain shared so Universal Control dispatch stays
consistent: the receiving Mac decides which app to launch. Hyper Guide itself
still shows the physical keyboard host's local choices.
Other files in `local/` are not automatically loaded.
Unused 1Password, Questrade, Mole, and Zed configuration is also excluded from Git.
Helix configuration remains shared.

Machine-local files stay where their applications expect them. Excluding files from
Git does not remove earlier copies from Git history.

## Review and apply updates

Run from `~/.config`:

```sh
python3 scripts/configctl.py status
python3 scripts/configctl.py plan
python3 scripts/configctl.py update keyboard
```

`plan` fetches remote changes and lists the components affected. `update` requires a
clean checkout and a fast-forward update. It refuses to pull if incoming changes
affect components you did not select. Select every component shown by the plan:

```sh
python3 scripts/configctl.py update keyboard neovim terminal other
```

Components are `keyboard` (Karabiner/Hammerspoon), `neovim`, `terminal`, and `other`.
This is a gate on a whole-repository update, not a way to pull individual folders.
A normal `git pull` bypasses the gate, and files in this active checkout take effect
as applications read them. An apply failure leaves the new commit checked out;
inspect the error and rerun `apply` after fixing it.

For edits already made locally:

```sh
python3 scripts/configctl.py apply keyboard
```

Keyboard apply builds Karabiner outputs, checks Hammerspoon links, reloads
Hammerspoon, and verifies that the helpers initialized. It requires installed
Karabiner build dependencies, Yarn, and the `hs` command. Test shortcuts manually
before committing. Terminal and other applications may need their own reloads.

## Neovim updates

The shared policy currently selects Neovim **0.12.x**. This is our chosen version
series, not a statement about the minimum version supported by any plugin.
The helper checks the installed binary against the current and incoming policy
before updating Neovim configuration. It never upgrades the Neovim application.

Update plugins deliberately on one Mac, test, and commit the resulting
`nvim/lazy-lock.json` with any configuration changes. On the receiving Mac, use:

```sh
python3 scripts/configctl.py update neovim
```

This uses `Lazy restore` to install the revisions in the committed lockfile.
`Lazy sync` also updates plugins and is not the command for reproducing the other
Mac's versions. If the receiving Mac has a changed lockfile, review it first;
the update helper will not discard or automatically stash it.

## One-time migration of existing Macs

**Before pulling the commit that removes local files from tracking on another Mac,
protect its existing files. A plain pull can otherwise delete tracked copies.**

With this helper available on that Mac, run:

```sh
python3 scripts/configctl.py protect-local
```

The helper copies currently tracked local files to
`~/.local/state/mac-config/backups/<timestamp>/`, then stages their removal from Git
tracking and verifies that their on-disk contents are unchanged. It is safe to run
again. Existing untracked sessions are left in place.

The initial migration leaves staged deletions and must be reconciled with the
shared migration commit before the normal clean-checkout update workflow can be
used. Preserve each Mac's backup while reconciling; do not force-reset or run a
plain pull over this initial migration. Review other local changes separately.
After migration, `protect-local` should report no tracked machine-local files.

## Verify the management helper

```sh
python3 scripts/test_configctl.py
```

Tests cover preservation of modified local files and sessions, private backup
permissions, repeated migration, and refusal of dirty or mixed-component updates.

## Fleet automatic sync

Published commits on `main` are checked every five minutes by Fleet on Devbox and
by a login-time LaunchAgent on each Mac. Macs fetch the published DevEnvConfig
reference over their existing SSH connection to Devbox. An offline machine keeps
its current settings and checks again after reconnecting. No machine auto-commits
or pushes local edits.

- Run `fleet config status --all` from either Mac for applied versions and blockers.
- Run `fleet config sync --all` from either Mac after publishing for an immediate check.
- On one machine, omit `--all` to check or update only that machine.
- Edit shared files, validate, commit and push to `Ampit/DevEnvConfig`. Tool-specific
  runtime versions remain in each project. Project `.env` files and secrets are not synced.

Devbox uses a separate source checkout in `~/workspace/personal/DevEnvConfig` and
only deploys the allowlist in `scripts/config_sync.py`: Neovim, btop/theme, Starship,
and the explicit Linux Zsh/tmux/lazygit files (including PATH for noninteractive SSH commands). The Linux files avoid Mac-only paths
and automatic tmux session restoration. Java paths are selected by OS. Selene on
Linux ARM is installed outside Mason. Authenticate Copilot explicitly.

The initial Devbox import requires a deliberate `--bootstrap` run and saves the
previous settings. Later runs use hashes of the last applied files to detect local
edits, including deletions. A conflict preserves the file and stops the batch.
Macs retain their existing active Git checkout: any dirty checkout or keyboard
configuration update needs attention/manual application. Configuration changes
wait while affected Neovim, btop or lazygit processes run. No running apps are
restarted; shell and tmux settings take effect in new sessions.

Backups and status live in `~/.local/state/fleet/config/`. A Linux deployment
failure restores the previous configuration files. Mac update failures retain a
backup and report attention; do not force-reset the checkout. Native plugin
updates run only when the lockfile changes and the editor is not running. The
updater verifies pinned plugin Git revisions. Binary/runtime upgrades remain an
explicit operation; the updater refuses an incompatible Neovim version policy.

The shared `zsh/.zshrc` is historical Mac config. The Macs currently load their
own `~/.zshrc`; those root shell files are intentionally not replaced automatically.
For Devbox shell changes, edit `linux/zshrc`. Portable settings belong in their
shared tool files; machine-private additions can go in `~/.config/local/zshrc`.
