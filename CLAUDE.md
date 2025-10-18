# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository providing a complete, automated development environment setup. **One command installs everything** on a new machine.

**Modern Stack**:
- **Neovim** with LazyVim + full language support (Rust, JS/TS, Go, C/C++, HTML/CSS, Vue)
- **Claude Code integration** via opencode.nvim
- **fnm** (Fast Node Manager) replaces nvm
- **Modern CLI tools** (ripgrep, fd, bat, eza, fzf, delta, zoxide)
- **Git tools** (gh, lazygit)
- **Tmux** with TPM and gruvbox theme
- **Automated LSP/formatter installation** for all languages

## One-Command Installation

```bash
git clone <repo-url> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

That's it! Everything is installed and configured automatically.

See `SETUP.md` for detailed setup guide.

## Installation System

**Automated bash installation** (no Ruby/Rake dependency):

The `install.sh` script orchestrates everything:
1. Detects OS (Ubuntu/WSL)
2. Installs system dependencies
3. Installs Neovim (latest stable AppImage)
4. Installs fnm + Node.js LTS
5. Installs Rust (via rustup)
6. Installs Go
7. Creates all symlinks (`.ln` files → `~/.*`)
8. Installs all LSP servers globally
9. Installs formatters
10. Installs modern CLI tools
11. Installs git tools

**Modular scripts** in `scripts/` can be run independently:
- `scripts/install-neovim.sh`
- `scripts/install-lsp-servers.sh`
- `scripts/install-formatters.sh`
- `scripts/install-cli-tools.sh`
- `scripts/create-symlinks.sh`
- etc.

**Symlink system** (replaces Rakefile):
- All `*.ln` files are auto-symlinked to `$HOME`
- Example: `bash/bashrc.ln` → `~/.bashrc`
- Existing files backed up with timestamp
- `nvim/` directory → `~/.config/nvim`

## Language Support

Neovim is configured with full LSP, formatting, and tooling for:

**Rust**:
- rust-analyzer LSP
- rustfmt formatting
- crates.nvim (Cargo.toml management)
- rustaceanvim (enhanced rust-analyzer)

**JavaScript/TypeScript**:
- tsserver LSP
- Prettier formatting
- typescript-tools.nvim
- package-info.nvim (package.json management)

**Vue.js**:
- Volar LSP
- Prettier formatting
- Auto-tag closing

**HTML/CSS**:
- html, cssls LSPs
- Prettier formatting
- Emmet completion
- Color preview

**Tailwind CSS**:
- tailwindcss LSP
- tailwind-tools.nvim

**Go**:
- gopls LSP
- goimports/gofmt formatting

**C/C++**:
- clangd LSP
- clang-format formatting

**Lua, Bash, JSON, YAML**: All supported with LSP + formatting

See `nvim/lua/plugins/lsp.lua` for complete configuration.

## Repository Structure

The dotfiles are organized by tool/category:

- **bash/**: Bash configuration files
  - `bashrc.ln`: Main bashrc that sources all `*.bash` files in the repo
  - `bash_profile.ln`: Sources bashrc and handles SSH keys
  - `functions.bash`: Custom bash functions (e.g., `t()` for repeating commands)

- **git/**: Git configuration and shell customization
  - `gitignore.ln`: Global gitignore
  - `aliases.bash`: Git aliases (`g`, `gs`, `ga`, `gc`, etc.)
  - `prompt.bash`: Git PS1 prompt configuration

- **vim/**: Classic Vim configuration (legacy, still maintained)
  - Uses vim-plug for plugin management
  - `vimrc.ln`: Main vimrc with plugins and settings
  - `vimrc.before.ln`, `vimrc.after.ln`: Additional configuration

- **nvim/**: Modern Neovim configuration with LazyVim
  - `init.lua`: Bootstrap lazy.nvim and load config
  - `lua/config/`: Core configuration (options, keymaps, autocmds)
  - `lua/plugins/`: Plugin specifications
    - `gruvbox.lua`: Theme configuration
    - `opencode.lua`: Claude Code integration
    - `markdown.lua`: Markdown rendering and preview
    - `core.lua`: Essential editor plugins
  - **Installation**: Must be manually symlinked: `ln -s ~/.dotfiles/nvim ~/.config/nvim`
  - See `nvim/README.md` for detailed documentation

- **tmux/**: Tmux configuration with TPM
  - `tmux.conf.ln`: Modern tmux config with TPM plugins
  - `aliases.bash`: Tmux convenience aliases (`tm`, `tml`, `tma`, etc.)
  - See `tmux/README.md` for detailed documentation

- **.claude/skills/**: Claude Code maintenance skills
  - `update-neovim-plugins/`: Update LazyVim and plugins
  - `update-dotfiles-trends/`: Research and suggest improvements
  - `sync-gruvbox-theme/`: Verify theme consistency
  - `backup-and-restore/`: Backup/restore configurations

## Key Bash Configuration Details

The bashrc automatically sources all `*.bash` files found in `~/.dotfiles`:
```bash
for f in $(find -L ~/.dotfiles -name \*.bash); do
  source $f
done
```

This means:
- New alias/function files can be added anywhere as `*.bash` and will be auto-sourced
- Changes to any `.bash` file require reloading shell or running `source ~/.bashrc`

## Environment Setup

The bashrc configures:
- **Editor**: vim
- **Go**: GOPATH at `$HOME/go`, GOBIN in PATH, GO111MODULE=on
- **Ruby**: GEM_HOME at `$HOME/gems`
- **Node**: nvm loaded from `$HOME/.nvm`
- **Rust**: Cargo environment loaded from `$HOME/.cargo/env`
- **PATH additions**: `$HOME/bin`, `$HOME/.local/bin`, `$HOME/gems/bin`, `$GOBIN`

## Git Workflow

Common git aliases defined in `git/aliases.bash`:
- `g` = `git` (with bash completion)
- `gs` = `git status`
- `ga` = `git add`
- `gc` = `git commit`
- `gca` = `git commit --amend`
- `glo` = `git log --oneline` (without signature check)
- `gd` = `git diff`
- `gpr` = `git pull --rebase`

## Editor Setup

### Neovim (Primary)

Modern neovim setup with LazyVim:

**Installation**:
```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
nvim  # First launch will install plugins
```

**Key Features**:
- **LazyVim**: Modern plugin framework with lazy loading
- **opencode.nvim**: Claude Code integration
  - `<leader>oa` - Ask Claude about current context
  - `<leader>os` - Select prompt template
  - `<leader>ot` - Toggle Claude Code panel
  - `<leader>oc` - Custom prompt
- **Markdown**: Inline rendering (render-markdown.nvim) + browser preview (markdown-preview.nvim)
  - `<leader>mp` - Toggle browser preview
- **Fuzzy finder**: Telescope (replaces ctrlp)
  - `<C-p>` - Find files
  - `<leader>fg` - Live grep
- **File explorer**: Neo-tree
  - `<leader>E` - Toggle explorer
- **Theme**: Gruvbox dark

**Plugin management**:
```vim
:Lazy sync    " Update all plugins
:Lazy clean   " Remove unused plugins
```

Leader key: `,` (comma)

**Configuration files**:
- `nvim/init.lua` - Entry point
- `nvim/lua/config/options.lua` - Vim options
- `nvim/lua/config/keymaps.lua` - Keybindings
- `nvim/lua/plugins/*.lua` - Plugin configs

### Vim (Classic)

Legacy vim setup (still functional):
- vim-plug for plugins
- Go, JavaScript/TypeScript support
- ctrlp for file navigation
- vim-fugitive for git
- Leader key: `,`

Both editors can be used side-by-side.

## Tmux Setup

Modern tmux configuration with TPM (Tmux Plugin Manager):

**Key Features**:
- Mouse support enabled
- Vi-mode keybindings
- TPM plugins:
  - tmux-sensible (sensible defaults)
  - tmux-yank (clipboard integration)
  - tmux-gruvbox (theme)
  - tmux-resurrect (save/restore sessions)
  - tmux-continuum (auto-save every 15min)
- Gruvbox theme (matches vim/neovim)

**Prefix**: `Ctrl+a` (not the default `Ctrl+b`)

**Key bindings**:
- `<prefix> |` - Split vertical
- `<prefix> -` - Split horizontal
- `<prefix> h/j/k/l` - Navigate panes (vim-style)
- `<prefix> =` - Maximize pane toggle
- `<prefix> r` - Reload config

**Plugin management**:
- Install plugins: `<prefix> + I` (capital I)
- Update plugins: `<prefix> + U`

**First launch**: TPM auto-installs if not present

See `tmux/README.md` for comprehensive documentation.

## Claude Code Skills

Custom skills for maintenance in `.claude/skills/`:

### update-neovim-plugins
Updates LazyVim and all plugins to latest versions.

**Usage**: Type `/update-neovim-plugins` in Claude Code

**What it does**:
- Runs `:Lazy sync` in neovim
- Reports what was updated
- Checks for breaking changes

### update-dotfiles-trends
Researches latest trends and suggests improvements.

**Usage**: Type `/update-dotfiles-trends` in Claude Code

**What it does**:
- Web search for latest tools/plugins
- Compares with current setup
- Suggests specific improvements

### sync-gruvbox-theme
Verifies gruvbox theme consistency across all tools.

**Usage**: Type `/sync-gruvbox-theme` in Claude Code

**What it does**:
- Checks vim, neovim, tmux configs
- Verifies color settings (256/true color)
- Reports inconsistencies

### backup-and-restore
Backup configs before changes, restore if needed.

**Usage**:
- Backup: `.claude/skills/backup-and-restore/backup.sh "reason"`
- Restore: `.claude/skills/backup-and-restore/restore.sh backup-YYYY-MM-DD-HHMMSS`

**What it does**:
- Creates timestamped backups in `~/.dotfiles-backups/`
- Backs up source + active configs + plugins
- Creates manifest with git commit reference
- Can restore to any previous backup

## Testing Changes

After modifying dotfiles:

**Bash changes**:
1. Test: `source ~/.bashrc`
2. Verify: Check aliases/functions work

**Symlinked configs**:
1. Add new `*.ln` files
2. Run: `rake install`
3. Verify: `ls -la ~/.<filename>`

**Neovim changes**:
1. Edit plugin configs in `nvim/lua/plugins/`
2. Reload neovim or run `:Lazy reload <plugin>`
3. Check `:checkhealth` for issues

**Tmux changes**:
1. Edit `tmux/tmux.conf.ln`
2. Run `rake install` (if first time)
3. Inside tmux: `<prefix> r` to reload

**Before major changes**: Use backup skill!
```bash
~/.dotfiles/.claude/skills/backup-and-restore/backup.sh "before major refactor"
```

## Installation Workflow

**New machine setup** (one command):
```bash
git clone <repo-url> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

The script handles everything automatically:
- Backs up existing configs
- Installs all tools and dependencies
- Creates all symlinks
- Sets up Neovim, tmux, bash, git configs

**After installation**:
```bash
source ~/.bashrc                # Reload shell
nvim                            # First launch installs plugins (2-3 min)
nvim +checkhealth               # Verify setup
tmux                            # Auto-installs TPM + plugins
```

**Installation options**:
- `./install.sh` - Full installation (recommended)
- `./install.sh --minimal` - Core only (dotfiles + neovim)
- `./install.sh --force` - Reinstall everything

**Individual components**:
```bash
./scripts/install-lsp-servers.sh   # Just LSP servers
./scripts/install-cli-tools.sh     # Just CLI tools
./scripts/create-symlinks.sh       # Just symlinks
```

## Important Notes

- Do not commit secrets or sensitive information
- Local customizations should go in `~/.bashrc.local` (sourced at end of bashrc)
- The repo expects `~/.git-prompt.sh` and `~/.git-completion.bash` for git integration
- Neovim config requires manual symlinking (not managed by Rakefile)
- Backup before major changes using the backup-and-restore skill
