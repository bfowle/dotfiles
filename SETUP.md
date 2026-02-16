# Dotfiles Setup Guide

Complete guide for setting up this development environment on a new machine.

## Quick Start (TL;DR)

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
source ~/.bashrc
nvim  # First launch installs plugins
tmux  # Press Ctrl+a then I to install plugins
```

## What Gets Installed

### Core Development Tools
- **Neovim** (latest stable) - Primary editor with LazyVim
- **fnm + Node.js** - Fast Node Manager with LTS Node
- **Rust** - Rust toolchain via rustup
- **Go** - Latest Go compiler
- **Build tools** - build-essential, cmake, pkg-config

### LSP Servers (Language Intelligence)
- **rust-analyzer** - Rust
- **tsserver** - TypeScript/JavaScript
- **vue_ls** - Vue.js
- **gopls** - Go
- **clangd** - C/C++
- **html, cssls** - HTML/CSS
- **tailwindcss** - Tailwind CSS
- **lua_ls** - Lua
- **bashls** - Bash

### Formatters
- **prettier/prettierd** - JS/TS/HTML/CSS/JSON/YAML/Markdown
- **stylua** - Lua
- **rustfmt** - Rust
- **goimports/gofmt** - Go
- **clang-format** - C/C++
- **black** - Python
- **shfmt** - Shell scripts

### Modern CLI Tools
- **ripgrep (rg)** - Faster grep
- **fd** - Faster find
- **bat** - Better cat with syntax highlighting
- **eza** - Better ls with icons
- **fzf** - Fuzzy finder
- **delta** - Better git diff
- **zoxide** - Smarter cd

### Git Tools
- **gh** - GitHub CLI
- **lazygit** - Terminal UI for git

### Terminal
- **tmux** with TPM - Terminal multiplexer with plugin manager
- **gruvbox theme** - Consistent across all tools

## System Requirements

- **OS**: macOS 12+, Ubuntu 20.04+, Debian 11+, or WSL2
- **Internet connection** (for downloading packages)
- **~2GB disk space** for all tools
- **sudo access** for system package installation (Linux/WSL)
- **Homebrew** on macOS (auto-installed if missing)

## Detailed Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run Installation

**Full installation** (recommended):
```bash
./install.sh
```

**Minimal installation** (just dotfiles + neovim):
```bash
./install.sh --minimal
```

**Force reinstall** (reinstall everything):
```bash
./install.sh --force
```

### 3. Reload Shell

```bash
source ~/.bashrc
```

Or close and reopen your terminal.

### 4. Launch Neovim

First launch will install LazyVim and all plugins (takes 2-3 minutes):

```bash
nvim
```

Wait for plugins to install, then check health:

```bash
nvim +checkhealth
```

### 5. Launch Tmux

First launch will auto-install TPM and plugins:

```bash
tmux
```

If plugins don't auto-install, press: `Ctrl+a` then `I` (capital I)

## Installation Script Details

The `install.sh` script detects your OS (macOS, Ubuntu/Debian, WSL) and uses the
appropriate package manager (Homebrew or apt). It runs these steps in order:

1. **System dependencies** - build tools, curl, git, python3, etc.
2. **Neovim** - Homebrew on macOS, AppImage on Linux
3. **Node.js** - fnm + LTS Node (cross-platform)
4. **Rust** - rustup + toolchain (cross-platform)
5. **Go** - Homebrew on macOS, tarball on Linux
6. **Symlinks** - All .ln files to home directory
7. **LSP servers** - Language servers for all languages
8. **Formatters** - Code formatters
9. **CLI tools** - ripgrep, fd, bat, eza, fzf, delta, zoxide
10. **Git tools** - gh, lazygit

Each step is modular and can be run independently from `scripts/` directory.

Steps 1-3 and 6 are critical (installer exits on failure). Steps 4-5 and 7-10 are
optional (installer warns and continues). A summary of successes and failures is
printed at the end. The installer is idempotent -- safe to re-run after partial failures.

## What Gets Symlinked

The installation creates these symlinks:

```
~/.bashrc          <- bash/bashrc.ln
~/.bash_profile    <- bash/bash_profile.ln
~/.gitignore       <- git/gitignore.ln
~/.tmux.conf       <- tmux/tmux.conf.ln
~/.vimrc           <- vim/vimrc.ln (optional, legacy)
~/.config/nvim     <- nvim/
```

All `.ln` files are automatically symlinked to `~/.*` (dot prefix added).

## Post-Installation Configuration

### GitHub CLI Authentication

```bash
gh auth login
```

### Git Configuration

If not already configured:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

Delta is auto-configured as the git pager.

### Neovim Plugin Management

Update plugins:
```vim
:Lazy sync
```

Clean unused plugins:
```vim
:Lazy clean
```

View installed plugins:
```vim
:Lazy
```

Install LSP server:
```vim
:Mason
```

### Tmux Plugin Management

- Install plugins: `Ctrl+a` + `I`
- Update plugins: `Ctrl+a` + `U`
- Remove plugins: `Ctrl+a` + `Alt+u`

## Language-Specific Setup

### Rust Projects

Neovim will automatically:
- Start rust-analyzer
- Show crate versions in Cargo.toml
- Provide code actions, refactoring
- Format on save with rustfmt

Keybindings:
- `<leader>rr` - Run runnables
- `<leader>rd` - Debug
- `<leader>re` - Expand macro
- `<leader>ct` - Toggle crate info

### TypeScript/JavaScript Projects

Neovim will automatically:
- Start tsserver
- Show inlay hints
- Manage package.json dependencies
- Format with prettier

Keybindings:
- `<leader>ns` - Show package info
- `<leader>nu` - Update package

### Go Projects

Neovim will automatically:
- Start gopls
- Format with goimports on save
- Run gofmt

### C/C++ Projects

Neovim will automatically:
- Start clangd
- Format with clang-format on save

### Web Development (Vue/React/HTML/CSS)

Neovim will automatically:
- Start vue_ls (Vue), html, cssls
- Tailwind CSS IntelliSense
- Emmet completion (`Ctrl+e`)
- Auto-close HTML tags
- Show color previews

## Neovim Keybindings

### General
- `<leader>` = `,` (comma)
- `<C-p>` - Fuzzy find files
- `<leader>fg` - Live grep
- `<leader>E` - File explorer

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>f` - Format buffer
- `[d` / `]d` - Previous/next diagnostic

### Claude Code Integration
- `<leader>oa` - Ask Claude about this
- `<leader>os` - Select prompt
- `<leader>ot` - Toggle Claude Code
- `<leader>oc` - Custom prompt

### Markdown
- `<leader>mp` - Toggle markdown preview

## Tmux Keybindings

**Prefix**: `Ctrl+a`

### Panes
- `prefix |` - Split vertical
- `prefix -` - Split horizontal
- `prefix h/j/k/l` - Navigate panes
- `prefix =` - Maximize pane

### Windows
- `prefix c` - Create window
- `prefix Ctrl+h/l` - Previous/next window

### Other
- `prefix r` - Reload config
- `prefix I` - Install plugins
- `prefix U` - Update plugins

## Modern CLI Usage

### Better grep (ripgrep)
```bash
rg "pattern" --type rust
rg "TODO" -g "*.js"
```

### Better find (fd)
```bash
fd "*.rs"
fd -e js -e ts
```

### Better cat (bat)
```bash
bat file.txt
cat file.txt  # aliased to bat
```

### Better ls (eza)
```bash
ls          # with icons
ll          # long format
la          # show hidden
lt          # tree view
```

### Fuzzy find (fzf)
- `Ctrl+r` - Search command history
- `Ctrl+t` - Find files
- `Alt+c` - Change directory

### Better cd (zoxide)
```bash
z project    # Jump to frequently used directory
z docs       # Fuzzy match
```

### Git UI (lazygit)
```bash
lg           # or: lazygit
```

## Troubleshooting

### Check Installation Log

```bash
cat ~/.dotfiles-install.log
```

### Neovim Issues

Check health:
```bash
nvim +checkhealth
```

Common issues:
- LSP not working: Run `:Mason` and ensure servers are installed
- Plugins not loading: Run `:Lazy sync`
- Treesitter errors: Run `:TSUpdate`

### Tmux Plugin Issues

If TPM doesn't auto-install:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then in tmux: `Ctrl+a` + `I`

### fnm/Node.js Issues

Manually install fnm:
```bash
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.bashrc
fnm install --lts
fnm use lts-latest
```

### Missing CLI Tools

Individual tools can be reinstalled:
```bash
# From dotfiles directory
./scripts/install-cli-tools.sh
./scripts/install-lsp-servers.sh
./scripts/install-formatters.sh
```

### Permission Issues

The install script should NOT be run with sudo. It will prompt for sudo when needed.

If you accidentally ran with sudo, fix ownership:
```bash
sudo chown -R $USER:$USER ~/.dotfiles
sudo chown -R $USER:$USER ~/.config/nvim
sudo chown -R $USER:$USER ~/.local
```

## Platform-Specific Notes

### macOS

- Homebrew is auto-installed if missing (supports both Apple Silicon and Intel)
- Clipboard works automatically via pbcopy/pbpaste
- Nerd Fonts are installed via `brew install --cask`
- Neovim, Go, CLI tools, and git tools are all installed via Homebrew

### WSL

- Clipboard integration uses `clip.exe` and `powershell.exe`
- Nerd Fonts must be installed on the Windows side (the installer downloads them
  and creates a PowerShell install script)

If clipboard is not working, install win32yank:
```bash
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```

### Docker (WSL)

Use Windows Docker Desktop instead of installing Docker in WSL.

## Backup and Restore

### Backup Current Config

```bash
~/.dotfiles/.claude/skills/backup-and-restore/backup.sh "before updates"
```

### Restore from Backup

```bash
~/.dotfiles/.claude/skills/backup-and-restore/restore.sh
# Select backup from list
```

## Updating

### Update Neovim Plugins

```vim
:Lazy sync
```

Or use Claude Code skill: `/update-neovim-plugins`

### Update Dotfiles

```bash
cd ~/.dotfiles
git pull
./install.sh --force
source ~/.bashrc
```

### Update LSP Servers

```vim
:Mason
# Press 'U' to update all
```

## Customization

### Local Overrides

Create `~/.bashrc.local` for machine-specific bash config:
```bash
# Custom aliases, environment variables, etc.
export CUSTOM_VAR="value"
```

This file is sourced at the end of `.bashrc` and not version controlled.

### Neovim Customization

Add custom plugins in `nvim/lua/plugins/`:
```lua
-- nvim/lua/plugins/custom.lua
return {
  {
    "author/plugin-name",
    config = function()
      -- configuration
    end,
  },
}
```

### Tmux Customization

Edit `tmux/tmux.conf.ln` and reload:
```bash
# Inside tmux
Ctrl+a then r
```

## Uninstallation

To remove everything:

```bash
# Remove installed tools
rm -rf ~/.local/share/fnm
rm -rf ~/.cargo
rm -rf ~/.fzf

# Linux only
sudo rm -rf /usr/local/go

# macOS only (if installed via Homebrew)
# brew uninstall neovim go ripgrep fd bat eza fzf git-delta zoxide gh lazygit

# Remove configs (be careful!)
rm ~/.bashrc ~/.bash_profile ~/.tmux.conf
rm -rf ~/.config/nvim
rm -rf ~/.tmux/plugins

# Restore backups if needed
~/.dotfiles/.claude/skills/backup-and-restore/restore.sh
```

## Getting Help

- Neovim docs: `:help`
- LazyVim docs: https://www.lazyvim.org
- Issues: Check `~/.dotfiles-install.log`
- Claude Code skills: `/update-dotfiles-trends` for suggestions

## Credits

- LazyVim: https://github.com/LazyVim/LazyVim
- tmux-gruvbox: https://github.com/egel/tmux-gruvbox
- Gruvbox: https://github.com/morhetz/gruvbox
- All the amazing plugin authors!
