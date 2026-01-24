# Dotfiles Setup Script Plan

## Current State
- Repo lives at `~/dotfiles`
- `~/.zshrc` manually sources `~/dotfiles/.zshrc`
- `.gitconfig` requires manual copy/symlink to `~/`
- Work files (`.zshrc.recharge.zsh`) stay untracked via gitignore

## Proposed Changes

### 1. Create `install.sh`
A bash script that:
- Symlinks dotfiles to `~/` (e.g., `~/.zshrc` -> `~/dotfiles/.zshrc.benheath.zsh`)
- Backs up existing files to `~/.dotfiles-backup/` before overwriting
- Is idempotent (safe to run multiple times)

Files to symlink:
- `.zshrc.benheath.zsh` -> `~/.zshrc`
- `.gitconfig` -> `~/.gitconfig`

### 2. Add local override support

**For git** — Add to `.gitconfig`:
```gitconfig
[include]
    path = ~/.gitconfig.local
```
Then on each machine, create `~/.gitconfig.local` with machine-specific settings (email, signing key, etc.)

**For zsh** — Add to end of `.zshrc.benheath.zsh`:
```zsh
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```
This lets you source work-specific files or machine overrides without committing them.

### 3. Update `.gitignore`
Keep current pattern but ensure `.local` files aren't accidentally committed.

### 4. Update `README.md`
Document the setup process:
```
git clone <repo> ~/dotfiles
cd ~/dotfiles && ./install.sh
# Optionally create ~/.gitconfig.local with [user] email = ...
```

## File Changes Summary

- `install.sh` — Create (new)
- `.gitconfig` — Add `[include]` for local overrides
- `.zshrc.benheath.zsh` — Add optional source of `~/.zshrc.local`
- `.zshrc` — Delete (no longer needed as indirection layer)
- `README.md` — Update with setup instructions
