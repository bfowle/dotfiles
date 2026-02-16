# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository providing a complete, automated development environment setup. **One command installs everything** on a new machine.

**Modern Stack**:
- **Neovim** with LazyVim + full language support (Rust, JS/TS, Go, C/C++, HTML/CSS, Vue)
- **fnm** (Fast Node Manager) replaces nvm
- **Modern CLI tools** (ripgrep, fd, bat, eza, fzf, delta, zoxide)
- **Git tools** (gh, lazygit)
- **Tmux** with TPM and gruvbox theme
- **Automated LSP/formatter installation** for all languages

## One-Command Installation

```bash
git clone <repo-url> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

That's it. Works on macOS, Ubuntu/Debian, and WSL. The installer detects your OS
and uses the appropriate package manager (Homebrew or apt). On macOS, Homebrew is
auto-installed if missing.

See `SETUP.md` for detailed setup guide.

## Installation System

**Automated bash installation** (no Ruby/Rake dependency):

The `install.sh` script orchestrates everything:
1. Detects OS (macOS, Ubuntu/Debian, WSL) and package manager (Homebrew or apt)
2. Ensures Homebrew is installed on macOS (auto-installs if missing)
3. Installs system dependencies
4. Installs Neovim (Homebrew on macOS, AppImage on Linux)
5. Installs fnm + Node.js LTS
6. Installs Rust (via rustup)
7. Installs Go (Homebrew on macOS, tarball on Linux)
8. Creates all symlinks (`.ln` files to `~/.*`)
9. Installs all LSP servers globally
10. Installs formatters
11. Installs modern CLI tools
12. Installs git tools

Critical steps (1-5, 8) exit on failure. Optional steps (6-7, 9-12) warn and
continue. A summary of successes/failures is printed at the end. The installer
is idempotent -- safe to re-run after partial failures.

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
    - `markdown.lua`: Markdown rendering and preview
    - `core.lua`: Essential editor plugins
    - `languages/cpp.lua`: C/C++ development configuration
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
- **Node**: fnm loaded from `$HOME/.local/share/fnm`
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

## Reloading Configuration

**Quick reload** (after making changes):
```bash
# Reload Neovim config (checks symlinks, shows status)
~/.dotfiles/scripts/reload-nvim.sh

# Then restart nvim or run inside nvim:
:Lazy sync
```

The reload script ensures:
- Symlink from `~/.config/nvim` to `~/.dotfiles/nvim` exists
- Config points to correct location
- Warns if nvim is running

## Testing Changes

After modifying dotfiles:

**Bash changes**:
1. Test: `source ~/.bashrc`
2. Verify: Check aliases/functions work

**Symlinked configs**:
1. Add new `*.ln` files
2. Run: `./scripts/create-symlinks.sh`
3. Verify: `ls -la ~/.<filename>`

**Neovim changes**:
1. Edit plugin configs in `nvim/lua/plugins/`
2. Run reload script: `~/.dotfiles/scripts/reload-nvim.sh`
3. Restart nvim (or run `:Lazy sync` inside nvim)
4. Check `:checkhealth` for issues
5. Verify leader key: `:echo mapleader` (should show `,`)

**Tmux changes**:
1. Edit `tmux/tmux.conf.ln`
2. Run `./scripts/create-symlinks.sh` (if first time)
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
- `./install.sh` - Full installation (recommended, idempotent)
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
- Neovim config is symlinked by `install.sh` (or `scripts/create-symlinks.sh`)
- Backup before major changes using the backup-and-restore skill
- **Leader key**: Set in TWO places in `nvim/init.lua` (both required due to LazyVim override):
  - Lines 3-4: Before `lazy.setup()` (required by lazy.nvim for proper keymap registration)
  - Lines 61-62: After `lazy.setup()` (actually works - LazyVim overrides to space during plugin load)
  - **Expected behavior**: May show lazy.nvim warning about setting leader - this is harmless, we set it correctly

## Troubleshooting

### Neovim: No Syntax Highlighting

If you open a file and see no syntax highlighting (all text is white/monochrome):

**Check Treesitter status**:
```vim
:checkhealth nvim-treesitter
```

**Install missing parsers manually**:
```vim
:TSInstall cpp c rust javascript typescript go lua bash
```

**Force reinstall all parsers**:
```vim
:TSInstall! all
```

**Verify parser is installed**:
```vim
:TSInstallInfo
```

**Common fixes**:
1. Restart Neovim after running `:Lazy sync`
2. Check that `nvim/lua/plugins/treesitter.lua` uses `require("nvim-treesitter.configs").setup()`
3. Ensure file type is detected: `:set filetype?` (should show `cpp`, `rust`, etc.)
4. Check theme supports Treesitter: `:colorscheme gruvbox`

### Neovim: C++ Language Features Not Working

If clangd isn't working or header/impl switching doesn't work:

**Check LSP status**:
```vim
:LspInfo
```

**Check if clangd is installed**:
```bash
which clangd
```

**Install via Mason**:
```vim
:Mason
# Press 'i' on clangd to install
```

**Check C++ plugins loaded**:
```vim
:Lazy
# Search for 'neovim-cmake' and 'nvim-dap'
```

**Verify languages subdirectory is imported**:
- File: `nvim/init.lua`
- Should have: `{ import = "plugins.languages" }`

### Neovim: Icons/Fonts Showing as Boxes

This happens when Nerd Fonts aren't installed **on Windows** (not WSL).

**Fix for Windows Terminal**:
1. Download Nerd Font: https://www.nerdfonts.com/font-downloads
2. Install `.ttf` files on Windows (right-click → Install)
3. Windows Terminal Settings → Profile → Appearance → Font Face
4. Select the Nerd Font you installed
5. Restart Windows Terminal

**Quick workaround** (disable icons):
```bash
# Remove icons from eza
alias ls='eza'
unalias ls='eza --icons'
```

### Tmux: True Color Not Working

**Check terminal**:
```bash
echo $TERM
# Should be: screen-256color (inside tmux) or xterm-256color (outside)
```

**Inside tmux**:
```vim
:checkhealth
# Should show "true color enabled"
```

**Fix**:
1. Ensure `tmux.conf` has: `set -g default-terminal "screen-256color"`
2. Ensure `bashrc` sets: `export TERM="xterm-256color"` (outside tmux only)
3. Reload: `tmux source-file ~/.tmux.conf`

### Neovim: Warning About Setting Leader Before Lazy

**Warning message**:
```
You need to set `vim.g.mapleader` **BEFORE** loading lazy
```

**Why this appears**:
- We set leader to comma BEFORE lazy.setup() (init.lua:3)
- LazyVim overrides it to space DURING lazy.setup()
- We set it back to comma AFTER lazy.setup() (init.lua:61)
- Lazy.nvim sees the "after" setting and warns about it

**This is expected and harmless!**
- The warning is cosmetic - leader key works correctly
- We must set it twice due to LazyVim's override behavior
- The keymaps are registered correctly because we set it before lazy.setup()

**Verify it works**:
```vim
:echo mapleader
# Should show: ,

# Press comma and wait - should see which-key menu
```
