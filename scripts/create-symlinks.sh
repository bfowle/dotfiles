#!/bin/bash
# Create all dotfile symlinks (replaces Rakefile)

source "$(dirname "$0")/common.sh"

log "Creating dotfile symlinks..."

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

# Function to create symlink
create_symlink() {
    local source=$1
    local target=$2

    # If target exists and is not a symlink, back it up
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        log_info "Backing up existing $target to ${target}${BACKUP_SUFFIX}"
        mv "$target" "${target}${BACKUP_SUFFIX}"
    fi

    # If target is a symlink, remove it
    if [[ -L "$target" ]]; then
        rm "$target"
    fi

    # Create symlink
    ln -sf "$source" "$target"
    log_info "Linked $target -> $source"
}

# Find all .ln files and create symlinks
while IFS= read -r -d '' file; do
    # Get the base name without .ln extension
    basename=$(basename "$file" .ln)
    # Add dot prefix for home directory
    target="$HOME/.$basename"

    create_symlink "$file" "$target"
done < <(find "$DOTFILES_DIR" -name "*.ln" -type f -print0)

# Special case: neovim config
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    mkdir -p "$HOME/.config"
    NVIM_TARGET="$HOME/.config/nvim"
    NVIM_SOURCE="$DOTFILES_DIR/nvim"

    if [[ -e "$NVIM_TARGET" ]] && [[ ! -L "$NVIM_TARGET" ]]; then
        log_info "Backing up existing neovim config to ${NVIM_TARGET}${BACKUP_SUFFIX}"
        mv "$NVIM_TARGET" "${NVIM_TARGET}${BACKUP_SUFFIX}"
    fi

    if [[ -L "$NVIM_TARGET" ]]; then
        rm "$NVIM_TARGET"
    fi

    ln -sf "$NVIM_SOURCE" "$NVIM_TARGET"
    log_info "Linked $NVIM_TARGET -> $NVIM_SOURCE"
fi

# Create necessary directories
mkdir -p "$HOME/.vim/tmp"
mkdir -p "$HOME/bin"

log "✓ All symlinks created successfully"
