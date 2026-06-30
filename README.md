# dotfiles

My personal macOS setup: WezTerm, tmux, Neovim, zsh.

## What's here

| File | Tool |
|------|------|
| `.wezterm.lua` | WezTerm terminal config |
| `.tmux.conf` | tmux config |
| `.config/nvim/` | Neovim config |
| `.zshrc` | zsh config (personal parts only) |

## Install on a new machine

```sh
git clone git@github-perso:tblanc-dev/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks everything into `$HOME` (backing up any existing files to `*.bak`).

## Machine-local / private config

`.zshrc` sources `~/.zshrc.local` at the end if it exists. That file is **not**
tracked — keep anything machine-specific, work-related, or secret (API keys,
private module paths, internal tooling) there so it never lands in this repo.
