autoload -Uz compinit
compinit

# ── Line editing: match the escape sequences WezTerm sends ───────────
# Cmd+Left / Cmd+Right  -> start / end of line   (Home / End)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line   # Home variant (some tmux/term setups)
bindkey '^[[4~' end-of-line         # End variant
# Option+Left / Option+Right -> previous / next word  (Ctrl-Left / Ctrl-Right)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# ── Go ───────────────────────────────────────────────────────────────
export GOPROXY=https://proxy.golang.org,direct
export PATH=$HOME/.local/bin:$PATH

# ── Git aliases ──────────────────────────────────────────────────────
alias rootrepo='cd $(git rev-parse --show-toplevel)' ## cd to git root repo
alias gits='git status -sb'                   # Short status (branch/file changes)
alias gita='git add'                          # Add files
alias gitaa='git add .'                       # Add all changes in the current directory
alias gitc='git commit -v'                    # Commit with verbose output
alias gitcm='git commit -m'                   # Commit with a message
alias gitca='git commit -av'                  # Commit all tracked changes with verbose output
alias gitco='git checkout'                    # Checkout/switch branches
alias gitb='git branch'                       # List all local branches
alias gitlg='git log --oneline --decorate --graph --all' # Pretty log history
alias gitp='git push'                         # Push to remote
alias gitpf='git push --force-with-lease'     # Safe force push
alias gitpl='git pull'                         # Pull from remote
alias gitl='git pull'                          # Pull from remote (short)
alias gitrh='git reset HEAD'                  # Unstage changes (soft reset)
alias gitcb='git checkout -b'                 # Create and switch to a new branch
alias gitdm='git branch -d'                   # Delete a local branch
alias gitDR='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'
alias gitpr='git pull --rebase'               # Pull and rebase instead of merge

# ── GitHub CLI (gh) aliases ──────────────────────────────────────────
brew upgrade gh
alias ghp='gh pr create --web'              # Create a standard PR, opening in the browser for details
alias ghpd='gh pr create --draft --fill'    # Create a Draft PR, filling title/body from git commit messages

# ── Prompt ───────────────────────────────────────────────────────────
eval "$(starship init zsh)"

export PATH=$(go env GOPATH)/bin:$PATH

# Clean up local branches across all repos under a parent dir (default: ..)
gitcleanb() {
    local parent_dir="${1:-..}"
    parent_dir=$(cd "$parent_dir" && pwd)

    for repo in "$parent_dir"/*(/); do
        [[ -d "$repo/.git" ]] || continue

        (
            cd "$repo" || return
            printf "Processing: \e[34m%s\e[0m\n" "${repo:t}"

            # 1. Checkout main or master (using -f to discard changes to tracked files)
            if git checkout -f main &>/dev/null || git checkout -f master &>/dev/null; then
                local current_branch=$(git branch --show-current)

                # 2. Discard any remaining state and update
                echo "  Resetting and pulling latest \e[32m$current_branch\e[0m..."
                git reset --hard HEAD &>/dev/null
                git pull &>/dev/null

                # 3. Identify and delete other branches
                local to_delete=$(git branch --format='%(refname:short)' | grep -vE '^(main|master)$')

                if [[ -n "$to_delete" ]]; then
                    echo "  Deleting local branches..."
                    echo "$to_delete" | xargs git branch -D
                else
                    echo "  No extra local branches to delete."
                fi
            else
                echo "  \e[31mError:\e[0m Could not find 'main' or 'master' branch. Skipping."
            fi
        )
        echo "--------------------------"
    done
}

# ── bun ──────────────────────────────────────────────────────────────
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── Machine-local / company config (NOT tracked in dotfiles) ─────────
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
