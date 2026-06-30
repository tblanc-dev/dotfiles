#!/usr/bin/env bash
# Symlink the tracked dotfiles into $HOME.
# Idempotent: re-running is safe. Existing real files are backed up to *.bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1" dst="$HOME/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "backing up existing $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

link ".zshrc"
link ".wezterm.lua"
link ".tmux.conf"
link ".config/nvim"

echo
echo "Done. Put any machine-local/company/secret settings in ~/.zshrc.local"
echo "(it is sourced by .zshrc but never tracked)."
