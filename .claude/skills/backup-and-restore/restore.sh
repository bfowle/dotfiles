#!/bin/bash
# Restore dotfiles from backup

if [ -z "$1" ]; then
  echo "Usage: $0 <backup-name>"
  echo ""
  echo "Available backups:"
  echo "=================="
  if [ -d ~/.dotfiles-backups ]; then
    ls -1t ~/.dotfiles-backups/ | head -10
  else
    echo "No backups found at ~/.dotfiles-backups"
  fi
  exit 1
fi

BACKUP_DIR="$HOME/.dotfiles-backups/$1"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup not found: $BACKUP_DIR"
  echo ""
  echo "Available backups:"
  ls -1t ~/.dotfiles-backups/ | head -10
  exit 1
fi

echo "========================================="
echo "Restore from Backup"
echo "========================================="
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""

if [ -f "$BACKUP_DIR/manifest.txt" ]; then
  cat "$BACKUP_DIR/manifest.txt"
else
  echo "Warning: No manifest file found"
  ls -lh "$BACKUP_DIR"
fi

echo ""
echo "========================================="
echo "WARNING: This will overwrite your current configuration!"
echo "========================================="
read -p "Continue with restore? (yes/NO) " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
  echo "Restore cancelled."
  exit 1
fi

# Create a backup of current state before restoring
echo "Creating safety backup of current state..."
SAFETY_BACKUP="$HOME/.dotfiles-backups/pre-restore-$(date +%Y-%m-%d-%H%M%S)"
mkdir -p "$SAFETY_BACKUP"
[ -d ~/.dotfiles ] && cp -r ~/.dotfiles "$SAFETY_BACKUP/dotfiles"
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$SAFETY_BACKUP/nvim"
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf "$SAFETY_BACKUP/tmux.conf"
echo "Safety backup created at: $SAFETY_BACKUP"
echo ""

# Restore files
echo "Restoring dotfiles..."
if [ -d "$BACKUP_DIR/dotfiles" ]; then
  cp -r "$BACKUP_DIR/dotfiles/"* ~/.dotfiles/
  echo "✓ Dotfiles restored"
fi

if [ -d "$BACKUP_DIR/nvim" ]; then
  mkdir -p ~/.config
  cp -r "$BACKUP_DIR/nvim" ~/.config/
  echo "✓ Neovim config restored"
fi

if [ -f "$BACKUP_DIR/tmux.conf" ]; then
  cp "$BACKUP_DIR/tmux.conf" ~/.tmux.conf
  echo "✓ Tmux config restored"
fi

if [ -f "$BACKUP_DIR/bashrc" ]; then
  cp "$BACKUP_DIR/bashrc" ~/.bashrc
  echo "✓ Bashrc restored"
fi

if [ -f "$BACKUP_DIR/bash_profile" ]; then
  cp "$BACKUP_DIR/bash_profile" ~/.bash_profile
  echo "✓ Bash profile restored"
fi

if [ -f "$BACKUP_DIR/vimrc" ]; then
  cp "$BACKUP_DIR/vimrc" ~/.vimrc
  echo "✓ Vimrc restored"
fi

if [ -d "$BACKUP_DIR/tmux-plugins" ]; then
  mkdir -p ~/.tmux
  cp -r "$BACKUP_DIR/tmux-plugins" ~/.tmux/plugins
  echo "✓ Tmux plugins restored"
fi

if [ -d "$BACKUP_DIR/nvim-data" ]; then
  mkdir -p ~/.local/share
  cp -r "$BACKUP_DIR/nvim-data" ~/.local/share/nvim
  echo "✓ Neovim data restored"
fi

echo ""
echo "========================================="
echo "✓ Restore Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Run 'cd ~/.dotfiles && rake install' to update symlinks"
echo "2. Reload your shell: 'source ~/.bashrc'"
echo "3. Restart tmux if running"
echo "4. Test neovim: 'nvim'"
echo ""
echo "If you need to rollback this restore, use:"
echo "  $0 $(basename "$SAFETY_BACKUP")"
