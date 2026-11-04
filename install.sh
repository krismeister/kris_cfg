#!/usr/bin/env bash
# Link all tracked configs from this repo into their live locations.
#
# Behavior per target:
#   - already a symlink         -> leave it alone, continue
#   - regular file/dir exists   -> move to a timestamped .bak, then link
#   - nothing exists            -> create parent dirs, then link
#
# Safe to re-run: existing symlinks are always skipped.
#
# Adding a new software: add one link_one line in the CONFIGS section below.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_one() {
  local src="$1" dest="$2"

  if [ -L "$dest" ]; then
    echo "SKIP: $dest already a symlink -> $(readlink "$dest")"
    return 0
  fi

  if [ -e "$dest" ]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    echo "BACKUP: $dest -> $backup"
    mv "$dest" "$backup"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "LINK: $dest -> $src"
}

# --- CONFIGS ---

# Muse: $XDG_CONFIG_HOME/muse, else ~/.config/muse
MUSE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/muse"
link_one "$REPO_DIR/muse/settings.json" "$MUSE_CONFIG/settings.json"

echo "Done."
