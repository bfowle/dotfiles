# Tmux Configuration

Modern tmux setup with TPM (Tmux Plugin Manager) and Gruvbox theme.

## Installation

The tmux configuration will be symlinked to `~/.tmux.conf` by the Rakefile.

To install manually:
```bash
rake install
```

## First Launch

On first launch, tmux will:
1. Auto-install TPM (Tmux Plugin Manager) if not present
2. Install all configured plugins

To manually install plugins:
```
<prefix> + I  (capital I)
```

## Key Features

### Prefix Key
- **Prefix**: `Ctrl+a` (instead of default `Ctrl+b`)
- Send prefix to nested session: `Ctrl+a` twice

### Pane Management
- **Split vertical**: `<prefix> |`
- **Split horizontal**: `<prefix> -`
- **Navigate**: `<prefix> h/j/k/l` (vim-style)
- **Resize**: `<prefix> Ctrl+h/j/k/l` (repeatable)
- **Maximize toggle**: `<prefix> =`
- **Quick cycle**: `<prefix> Ctrl+A`

### Window Management
- **Previous**: `<prefix> Ctrl+h`
- **Next**: `<prefix> Ctrl+l`
- Windows start at 1 (not 0)
- Auto-renumber when closed

### Copy Mode (Vi-style)
- **Enter copy mode**: `<prefix> [`
- **Visual selection**: `v`
- **Copy**: `y` or `Enter`
- **Paste**: `<prefix> ]`
- **Mouse selection**: Auto-copies to clipboard

### Session Management
- **Save session**: Automatic every 15 minutes (tmux-continuum)
- **Restore session**: Automatic on tmux start
- **Manual save**: Handled by tmux-resurrect

### Other
- **Reload config**: `<prefix> r`
- **Mouse support**: Enabled (click panes, resize, scroll)
- **Vi mode**: All keybindings use vi-style
- **Gruvbox theme**: Dark variant (matches vim/neovim)

## Plugins (via TPM)

### Core
- **tpm**: Tmux Plugin Manager
- **tmux-sensible**: Sensible default settings

### Features
- **tmux-yank**: Enhanced clipboard integration
- **tmux-resurrect**: Save/restore sessions
- **tmux-continuum**: Automatic session save/restore

### Theme
- **tmux-gruvbox**: Gruvbox color scheme

## Plugin Management

### Install plugins
```
<prefix> + I
```

### Update plugins
```
<prefix> + U
```

### Remove unlisted plugins
```
<prefix> + alt + u
```

## Configuration Structure

```
tmux/
├── tmux.conf.ln        # Main config (symlinked to ~/.tmux.conf)
├── aliases.bash        # Tmux convenience aliases
└── README.md           # This file
```

## Bash Aliases

Defined in `tmux/aliases.bash`:
- `tm` - Create new session with custom layout
- `tml` - List sessions
- `tma` - Attach to session
- `tmc` - Clear history
- `tmk` - Kill session

## Updating Configuration

After modifying `tmux.conf.ln`:
```bash
<prefix> r  # Reload config inside tmux
```

Or restart tmux:
```bash
tmux kill-server
tmux
```

## Clipboard Integration

The configuration uses `xclip` for clipboard integration on Linux. Ensure it's installed:
```bash
sudo apt install xclip  # Debian/Ubuntu
```

For macOS, the config will need modification to use `pbcopy`/`pbpaste`.

## Neovim Integration

Special settings for neovim:
- `escape-time 0` - No delay on ESC key
- `focus-events on` - Enable autoread in neovim
- `tmux-resurrect` saves neovim sessions

## Compatibility

This configuration is compatible with tmux 2.9+. Some features require:
- 256 color terminal support
- True color support for best appearance
- xclip for clipboard integration (Linux)

## Gruvbox Theme

The tmux-gruvbox plugin provides:
- Consistent color scheme with vim/neovim
- Status bar styling
- Pane border colors
- Window status indicators

Theme variant can be changed in `tmux.conf.ln`:
```
set -g @tmux-gruvbox 'dark'  # or 'light'
```
