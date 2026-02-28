#!/bin/bash

# Dotfiles install script
# Creates symlinks from ~ to ~/dotfiles
# Backs up existing files before overwriting

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"
INSTALL_BREW=false

for arg in "$@"; do
    case "$arg" in
        --brew) INSTALL_BREW=true ;;
    esac
done

# Files to symlink: "source:target"
FILES=(
    ".zshrc:.zshrc"
    ".gitconfig:.gitconfig"
    ".gitignore_global:.gitignore_global"
    ".claude:.claude"
)

backup_and_link() {
    local source="$1"
    local target="$2"
    local source_path="$DOTFILES_DIR/$source"
    local target_path="$HOME/$target"

    # Skip if already correctly linked
    if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
        echo "✓ $target already linked"
        return
    fi

    # Backup existing file if it exists and is not a symlink to our file
    if [[ -e "$target_path" || -L "$target_path" ]]; then
        local backup_name="$target.$(date +%Y%m%d%H%M%S)"
        mkdir -p "$(dirname "$BACKUP_DIR/$backup_name")"
        mv "$target_path" "$BACKUP_DIR/$backup_name"
        echo "  Backed up $target to $BACKUP_DIR/$backup_name"
    fi

    # Create parent directory if needed and symlink
    mkdir -p "$(dirname "$target_path")"
    ln -s "$source_path" "$target_path"
    echo "✓ Linked $target -> $source_path"
}

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

for entry in "${FILES[@]}"; do
    source="${entry%%:*}"
    target="${entry##*:}"
    backup_and_link "$source" "$target"
done

# Set global gitignore
git config --global core.excludesFile ~/.gitignore_global
echo "✓ Set global core.excludesFile"

# Symlink ~/dev -> ~/Developer for convenience
if [[ -L "$HOME/dev" && "$(readlink "$HOME/dev")" == "$HOME/Developer" ]]; then
    echo "✓ ~/dev already linked"
elif [[ -e "$HOME/dev" || -L "$HOME/dev" ]]; then
    echo "  ~/dev already exists and is not a symlink to ~/Developer — skipping"
else
    ln -s "$HOME/Developer" "$HOME/dev"
    echo "✓ Linked ~/dev -> ~/Developer"
fi

if [[ "$INSTALL_BREW" == true ]]; then
    echo ""
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "Installing Homebrew packages from Brewfile..."
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        echo "Skipping Brewfile (not macOS)"
    fi
fi

if [[ "$(uname)" != "Darwin" ]]; then
    # Ensure zsh is installed and set as default shell
    if ! command -v zsh &> /dev/null; then
        echo "Installing zsh..."
        sudo apt-get update && sudo apt-get install -y zsh
    fi

    if [[ "$SHELL" != *"zsh"* ]]; then
        echo "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        echo "Note: Log out and back in for the shell change to take effect"
    fi
fi

echo ""
echo "Done! You may want to create these optional local override files:"
echo "  ~/.gitconfig.local   - for machine-specific git settings (email, signing key)"
echo "  ~/dotfiles/.zshrc.local   - for machine-specific shell config (gitignored)"
