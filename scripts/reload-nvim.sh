#!/bin/bash

# Reload Neovim configuration
# This script ensures config symlinks are correct and reloads nvim

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
NVIM_CONFIG="$HOME/.config/nvim"

echo "🔄 Reloading Neovim configuration..."

# Ensure nvim config symlink exists
if [ ! -L "$NVIM_CONFIG" ]; then
    echo "⚠️  $NVIM_CONFIG is not a symlink!"
    echo "   Creating symlink..."

    # Backup existing config if it's a directory
    if [ -d "$NVIM_CONFIG" ] && [ ! -L "$NVIM_CONFIG" ]; then
        BACKUP="$NVIM_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   Backing up existing config to $BACKUP"
        mv "$NVIM_CONFIG" "$BACKUP"
    fi

    # Create symlink
    ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG"
    echo "✅ Created symlink: $NVIM_CONFIG -> $DOTFILES_DIR/nvim"
fi

# Verify symlink points to dotfiles
CURRENT_TARGET=$(readlink "$NVIM_CONFIG")
if [ "$CURRENT_TARGET" != "$DOTFILES_DIR/nvim" ]; then
    echo "⚠️  Symlink points to wrong location: $CURRENT_TARGET"
    echo "   Fixing..."
    ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG"
    echo "✅ Fixed symlink"
fi

echo "📂 Config location: $NVIM_CONFIG -> $(readlink $NVIM_CONFIG)"

# Check if nvim is running
if pgrep -x nvim > /dev/null; then
    echo ""
    echo "⚠️  Neovim is currently running!"
    echo "   To apply changes, you need to:"
    echo "   1. Close all nvim instances (:qa)"
    echo "   2. Restart nvim"
    echo ""
    echo "   Or run this in nvim to reload plugins:"
    echo "   :Lazy sync"
else
    echo "✅ No running nvim instances detected"
    echo ""
    echo "🎉 Configuration ready!"
    echo "   Start nvim to use the new config"
    echo ""
    echo "   Verify leader key is comma:"
    echo "   :echo mapleader"
    echo "   (should show: ,)"
fi
