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

`local/` is only an ignored storage directory; applications do not load it automatically.
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
