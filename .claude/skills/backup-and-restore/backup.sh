#!/bin/bash
# Backup dotfiles configuration

BACKUP_DIR="$HOME/.dotfiles-backups/backup-$(date +%Y-%m-%d-%H%M%S)"
REASON="${1:-Manual backup}"

mkdir -p "$BACKUP_DIR"

echo "Creating backup: $BACKUP_DIR"

# Backup dotfiles source
echo "Backing up dotfiles source..."
cp -r ~/.dotfiles "$BACKUP_DIR/dotfiles"

# Backup actual configs
echo "Backing up active configurations..."
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim"
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf"
[ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_DIR/bashrc"
[ -f ~/.bash_profile ] && cp ~/.bash_profile "$BACKUP_DIR/bash_profile"
[ -f ~/.vimrc ] && cp ~/.vimrc "$BACKUP_DIR/vimrc"

# Backup plugins
echo "Backing up plugin directories..."
[ -d ~/.tmux/plugins ] && cp -r ~/.tmux/plugins "$BACKUP_DIR/tmux-plugins"
[ -d ~/.local/share/nvim ] && cp -r ~/.local/share/nvim "$BACKUP_DIR/nvim-data"

# Create manifest
cat > "$BACKUP_DIR/manifest.txt" <<EOF
Backup created: $(date)
Dotfiles path: ~/.dotfiles
Git commit: $(cd ~/.dotfiles && git rev-parse HEAD 2>/dev/null || echo "not in git")
Git branch: $(cd ~/.dotfiles && git branch --show-current 2>/dev/null || echo "not in git")
Reason: $REASON

Files backed up:
$(find "$BACKUP_DIR" -type f | wc -l) files
$(du -sh "$BACKUP_DIR" | cut -f1) total size

Directory structure:
$(tree -L 2 "$BACKUP_DIR" 2>/dev/null || find "$BACKUP_DIR" -maxdepth 2 -type d)
EOF

echo ""
echo "✓ Backup created successfully!"
echo "Location: $BACKUP_DIR"
echo ""
cat "$BACKUP_DIR/manifest.txt"

# Compress backups older than 30 days
echo ""
echo "Compressing old backups..."
find ~/.dotfiles-backups -maxdepth 1 -type d -name "backup-*" -mtime +30 | while read dir; do
  if [ ! -f "$dir.tar.gz" ]; then
    echo "Compressing: $dir"
    tar -czf "$dir.tar.gz" -C "$(dirname "$dir")" "$(basename "$dir")" && rm -rf "$dir"
  fi
done

echo "✓ Backup complete!"
