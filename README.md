# kris_cfg

Personal global configs. Each subdirectory mirrors one software's live
config files.

## Use

```sh
./install.sh
```

Per file: existing symlink is left alone, existing real file is moved to
a timestamped `.bak` backup, then the tracked copy is symlinked into
place. Safe to re-run.

## Configs

- `muse/` → `~/.config/muse/settings.json`
- `shell/` → `~/.bashrc_personal` (plus a source line in `~/.bashrc`)
- `nvim/` → `~/.config/nvim/lua/kris_prefs.lua` (plus a require line in `~/.config/nvim/init.lua`)

## Add a software

1. Put its files in a new subdirectory.
2. Add a `link_one` line in `install.sh`.
3. List it above. Keep secrets out of git (see `.gitignore`; agents must run `./check-secrets.sh` before committing).
