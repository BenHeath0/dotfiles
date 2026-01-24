# Dotfiles

Personal development environment configuration.

## Setup

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The install script will:
- Symlink dotfiles to `~/`
- Back up any existing files to `~/.dotfiles-backup/`

To install Homebrew packages:
```bash
brew bundle --file=~/dotfiles/Brewfile
```

## Machine-Specific Config

Create these optional files for per-machine settings (not tracked in git):

**~/.gitconfig.local** — Git user info, signing keys, etc.
```gitconfig
[user]
    email = you@work.com
```

**~/dotfiles/.zshrc.local** — Shell aliases, paths, work-specific config (gitignored)
```zsh
export WORK_API_KEY="..."
alias myproject="cd ~/work/myproject"
```

## Files

- `.zshrc.benheath.zsh` — Main zsh config (symlinked to `~/.zshrc`)
- `.gitconfig` — Git aliases and settings (symlinked to `~/.gitconfig`)
- `.bash_profile.benheath.bash` — Bash config (if needed)
- `.git-completion.bash` — Git tab completion
- `install.sh` — Setup script
- `Brewfile` — Homebrew packages, casks, and VS Code extensions
