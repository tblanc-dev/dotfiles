---
name: dotfiles
description: Managing the personal dotfiles repo at ~/dotfiles (WezTerm, tmux, Neovim, zsh configs symlinked into $HOME and pushed to personal GitHub). Use when editing tracked dotfiles, pushing config changes, adding a new config to the repo, or handling the personal-vs-company git/SSH identity split.
---

# Personal dotfiles

Repo at `~/dotfiles` → github.com/tblanc-dev/dotfiles (**personal, public**), kept
separate from company work.

## Layout
- Tracked configs are **symlinked** from `$HOME` into `~/dotfiles`, so editing the
  file in place edits the repo. Edit dotfiles in place — no need to touch
  `~/dotfiles/...` directly.
- Tracked: `.wezterm.lua`, `.tmux.conf`, `.config/nvim/`, `.zshrc`
  (plus `install.sh`, `.gitignore`, `README.md`).
- `~/.zshrc` sources `~/.zshrc.local` at the end. `~/.zshrc.local` is **NOT tracked**
  and holds everything company-specific or secret (bedrock-cli, GOPRIVATE,
  New Relic key, Java env).

## Identity (keep company and personal separate)
- Per-repo identity: `TBlanc <theo.blanc38@gmail.com>` — NOT the global company
  identity (`tblanc.externe@bedrockstreaming.com`).
- Remote uses SSH alias `github-perso` (→ github.com, key `~/.ssh/id_ed25519_personal`,
  `IdentitiesOnly yes`). Company GHES uses `github-pro` (→ github.m6web.fr). Don't mix.

## Pushing changes
```sh
cd ~/dotfiles && git add -A && git commit -m "..." && git push
```
Remote and tracking branch are already configured; no re-setup needed.

## Rules
- The repo is **public**: never add secrets or company config. Those go only in
  `~/.zshrc.local`.
- New machine setup: `git clone git@github-perso:tblanc-dev/dotfiles.git ~/dotfiles`
  then `~/dotfiles/install.sh`, then recreate `~/.zshrc.local`.
