# Dotfiles

Modern, fully automated development environment for Linux/WSL.

## ⚡ Quick Start

```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Wait 5-10 minutes, then:

```bash
source ~/.bashrc
nvim  # First launch installs plugins
tmux
```

That's it! Everything is configured.

## 📦 What's Included

### Development Tools
- **Neovim** with LazyVim
- **Node.js** via fnm (Fast Node Manager)
- **Rust** via rustup
- **Go** compiler
- **Build tools** (gcc, cmake, etc.)

### Language Support (LSP + Formatting)
- Rust (rust-analyzer, rustfmt)
- TypeScript/JavaScript (tsserver, prettier)
- Vue.js (volar)
- Go (gopls, goimports)
- C/C++ (clangd, clang-format)
- HTML/CSS (html, cssls, prettier)
- Tailwind CSS
- Lua, Bash, JSON, YAML

### Modern CLI Tools
- **ripgrep** - Better grep
- **fd** - Better find
- **bat** - Better cat
- **eza** - Better ls
- **fzf** - Fuzzy finder
- **delta** - Better git diff
- **zoxide** - Smarter cd
- **gh** - GitHub CLI
- **lazygit** - Git TUI

### Terminal & Editor
- **Tmux** with TPM + plugins
- **Gruvbox theme** everywhere
- **Claude Code** integration

## 📖 Documentation

- **[SETUP.md](SETUP.md)** - Comprehensive setup guide
- **[CLAUDE.md](CLAUDE.md)** - Guide for Claude Code

## ⚙️ Installation Options

```bash
./install.sh            # Full installation (recommended)
./install.sh --minimal  # Just dotfiles + neovim
./install.sh --force    # Reinstall everything
```

## 🔑 Key Features

### Neovim
- **Claude Code integration**: `<leader>oa` to ask Claude
- **LSP everywhere**: Full language support out of the box
- **Auto-formatting**: Format on save for all languages
- **Fuzzy finding**: `Ctrl+p` for files
- **Treesitter**: Advanced syntax highlighting

### Tmux
- **Prefix**: `Ctrl+a` (not `Ctrl+b`)
- **Vi-mode** keybindings
- **Mouse support** enabled
- **Session persistence** with resurrect/continuum
- **Gruvbox theme**

### Bash
- **fnm** for Node.js (faster than nvm)
- **Modern aliases** (ls→eza, cat→bat, cd→zoxide)
- **fzf integration** (`Ctrl+r` for history, `Ctrl+t` for files)
- **Git prompt** with status

## 🛠️ Development Workflows

### Rust Project
```bash
cd my-rust-project
nvim
# rust-analyzer, rustfmt, crates.nvim all active
# <leader>rr to run, <leader>ct for crate info
```

### TypeScript/Next.js Project
```bash
cd my-nextjs-project
nvim
# tsserver, volar, tailwindcss LSP all active
# Prettier formatting on save
```

### Go Project
```bash
cd my-go-project
nvim
# gopls, goimports all active
# Format on save
```

## 🔄 Updating

### Update Everything
```bash
cd ~/.dotfiles
git pull
./install.sh --force
```

### Update Just Neovim Plugins
```vim
:Lazy sync
```

Or use Claude Code skill: `/update-neovim-plugins`

## 💾 Backup & Restore

```bash
# Backup before changes
~/.dotfiles/.claude/skills/backup-and-restore/backup.sh "reason"

# Restore from backup
~/.dotfiles/.claude/skills/backup-and-restore/restore.sh
```

## 🐛 Troubleshooting

Check installation log:
```bash
cat ~/.dotfiles-install.log
```

Check Neovim health:
```bash
nvim +checkhealth
```

See [SETUP.md](SETUP.md) for detailed troubleshooting.

## 📝 Customization

### Local Bash Overrides
Create `~/.bashrc.local`:
```bash
export MY_VAR="value"
alias myalias="command"
```

### Custom Neovim Plugins
Add to `nvim/lua/plugins/custom.lua`:
```lua
return {
  { "author/plugin-name", opts = {} },
}
```

## 🗂️ Structure

```
.
├── install.sh              # Main installation script
├── scripts/                # Modular installation scripts
├── bash/                   # Bash configs (*.bash auto-sourced)
├── git/                    # Git configs
├── nvim/                   # Neovim config (LazyVim)
│   └── lua/
│       ├── config/         # Core settings
│       └── plugins/        # Plugin configs
├── tmux/                   # Tmux config
├── vim/                    # Legacy vim (optional)
└── .claude/skills/         # Claude Code skills
```

## 🎯 System Requirements

- Ubuntu 20.04+, Debian 11+, or WSL2
- ~2GB disk space
- Internet connection
- sudo access

## 📄 License

MIT

## 🙏 Credits

Built with:
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [Gruvbox](https://github.com/morhetz/gruvbox)
- Many amazing open source tools!
