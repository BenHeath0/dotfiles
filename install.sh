#!/bin/bash

# Dotfiles install script
# Creates symlinks from ~ to ~/dev dotfiles
# Backs up existing files before overwriting

set -e

DOTFILES_DIR="$HOME/dev"
BACKUP_DIR="$HOME/.dotfiles-backup"

# Files to symlink: "source:target"
FILES=(
    ".zshrc.benheath.zsh:.zshrc"
    ".gitconfig:.gitconfig"
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
        mkdir -p "$BACKUP_DIR"
        local backup_name="$target.$(date +%Y%m%d%H%M%S)"
        mv "$target_path" "$BACKUP_DIR/$backup_name"
        echo "  Backed up $target to $BACKUP_DIR/$backup_name"
    fi

    # Create symlink
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

echo ""
echo "Done! You may want to create these optional local override files:"
echo "  ~/.gitconfig.local   - for machine-specific git settings (email, signing key)"
echo "  ~/dev/.zshrc.local   - for machine-specific shell config (gitignored)"
