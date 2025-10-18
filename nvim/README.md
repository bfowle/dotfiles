# Neovim Configuration

Modern Neovim setup using LazyVim with Claude Code integration.

## Installation

The neovim configuration will be symlinked to `~/.config/nvim` by the Rakefile.

To install manually:
```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

## First Launch

On first launch, neovim will:
1. Install lazy.nvim plugin manager
2. Install LazyVim
3. Install all configured plugins

This may take a few minutes.

## Key Features

### Claude Code Integration (opencode.nvim)
- `<leader>oa` - Ask Claude about current context
- `<leader>os` - Select from prompt templates
- `<leader>ot` - Toggle Claude Code panel
- `<leader>oc` - Custom Claude prompt

### Markdown Support
- **Inline rendering**: Automatically renders markdown in buffer (render-markdown.nvim)
- **Browser preview**: `<leader>mp` to toggle live preview in browser

### Theme
- Gruvbox dark theme (matching tmux and vim)
- 256 color terminal support

### File Navigation
- `<C-p>` - Fuzzy file finder (Telescope)
- `<leader>E` - File explorer (Neo-tree)
- `<leader><leader>` - Jump to alternate file

### Plugins

#### Core
- **LazyVim**: Base configuration and plugin ecosystem
- **lazy.nvim**: Fast plugin manager with lazy loading
- **which-key**: Show available keybindings

#### Editor
- **nvim-treesitter**: Syntax highlighting and code understanding
- **telescope.nvim**: Fuzzy finder
- **neo-tree.nvim**: File explorer
- **gitsigns.nvim**: Git integration
- **Comment.nvim**: Easy commenting
- **nvim-autopairs**: Auto close brackets/quotes

#### Markdown
- **render-markdown.nvim**: Inline markdown rendering
- **markdown-preview.nvim**: Browser-based preview

#### Claude Code
- **opencode.nvim**: Claude Code integration with auto-reload

## Configuration Structure

```
nvim/
├── init.lua                    # Entry point, bootstraps lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua        # Vim options
│   │   ├── keymaps.lua        # Key mappings
│   │   └── autocmds.lua       # Auto commands
│   └── plugins/
│       ├── gruvbox.lua        # Theme configuration
│       ├── opencode.lua       # Claude Code integration
│       ├── markdown.lua       # Markdown plugins
│       └── core.lua           # Core editor plugins
└── README.md                   # This file
```

## Updating Plugins

To update all plugins:
```vim
:Lazy sync
```

Or use the Claude Code skill: `/update-neovim-plugins`

## Customization

Add new plugins by creating files in `lua/plugins/`. Each file should return a table of plugin specs.

Example:
```lua
-- lua/plugins/myplugin.lua
return {
  "author/plugin-name",
  config = function()
    -- plugin configuration
  end,
}
```

## Leader Key

The leader key is `,` (comma) for consistency with the existing vim configuration.

## Compatibility

This configuration runs side-by-side with the existing vim setup in `vim/`. Both can be used independently.
