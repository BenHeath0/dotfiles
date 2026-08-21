# Dotfiles

Personal development environment configuration.

## Setup

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The install script will:
- Symlink dotfiles to `~/` (backing up any existing files to `~/.dotfiles-backup/`)
- Symlink VS Code settings and keybindings to `~/Library/Application Support/Code/User/` (macOS only)
- Set `.gitignore_global` as git's global `core.excludesFile`
- Symlink `~/dev` -> `~/Developer`
- On Linux: install zsh and set it as the default shell

To also install Homebrew packages, casks, and VS Code extensions:
```bash
./install.sh --brew
# or standalone:
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

- `.zshrc` — Main zsh config (symlinked to `~/.zshrc`)
- `.gitconfig` — Git aliases and settings (symlinked to `~/.gitconfig`)
- `.gitignore_global` — Global git ignores (symlinked to `~/.gitignore_global`)
- `.claude` — Claude Code config (symlinked to `~/.claude`)
- `vscode/` — VS Code `settings.json` and `keybindings.json` (symlinked into `~/Library/Application Support/Code/User/`)
- `.bash_profile.benheath.bash` / `.bash_profile.recharge.bash` — Bash configs (if needed)
- `.git-completion.bash` / `.git-completion.zsh` — Git tab completion
- `install.sh` — Setup script
- `Brewfile` — Homebrew packages, casks, and VS Code extensions
- `SETUP_PLAN.md` — Original setup planning notes
