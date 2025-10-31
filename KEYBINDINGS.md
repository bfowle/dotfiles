# Neovim Keybindings Reference

- **Leader key**: `,` (comma)
- **Local leader**: `\` (backslash)

> **IMPORTANT**: If leader key shows as ` ` (space) instead of `,` (comma):
> 1. **Close ALL nvim instances completely** (close terminal/window, not just `:q`)
> 2. **Open fresh nvim**
> 3. **Verify**: Run `:echo mapleader` in nvim - should show `,` not ` `
> 4. **Test**: Press `,` and wait - should see which-key popup with options
>
> **Tip**: Press `,` (comma) and wait ~300ms to see available keybindings with which-key

---

## General Navigation

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left window |
| `Ctrl+j` | Move to window below |
| `Ctrl+k` | Move to window above |
| `Ctrl+l` | Move to right window |

### Tab Navigation
| Key | Action |
|-----|--------|
| `]t` | Next tab (vim-style, **no comma**) |
| `[t` | Previous tab (vim-style, **no comma**) |
| `gt` | Next tab (native vim) |
| `gT` | Previous tab (native vim) |
| `,tn` | New tab |
| `,tc` | Close tab |
| `,to` | Close other tabs |
| `Ctrl+Shift+J` | Previous tab (legacy) |
| `Ctrl+Shift+K` | Next tab (legacy) |

**Note**: Tab navigation with brackets (`]t`, `[t`) does NOT use the leader key (comma). Just press `]` then `t`.

### TODO Comment Navigation
| Key | Action |
|-----|--------|
| `]T` | Next TODO comment (capital T) |
| `[T` | Previous TODO comment (capital T) |
| `,st` | Search TODO comments (Telescope) |
| `,sT` | Search TODO/FIX/FIXME (Telescope) |

### Buffer Navigation
| Key | Action |
|-----|--------|
| `<leader><leader>` | Switch to alternate file (previous buffer) |
| `<leader>fb` | List and search buffers (Telescope) |

---

## File Operations

### Finding Files
| Key | Action |
|-----|--------|
| `Ctrl+p` | Find files (Telescope) |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (search in files) |
| `<leader>E` | Toggle file explorer (Neo-tree) |

### File Operations in Current Directory
| Key | Action |
|-----|--------|
| `<leader>e` | Edit file in current directory |
| `<leader>v` | Open file in vertical split (current dir) |
| `%%` | (Command mode) Expand to current file's directory |

---

## Editing

### Insert Mode
| Key | Action |
|-----|--------|
| `jk` or `jj` | Exit insert mode (better-escape) |

### Normal Mode
| Key | Action |
|-----|--------|
| `Enter` | Clear search highlighting |
| `<leader>w` | Clean whitespace (remove trailing spaces, fix tabs) |

### Visual Mode
| Key | Action |
|-----|--------|
| `<` | Indent left (stays in visual mode) |
| `>` | Indent right (stays in visual mode) |
| `J` | Move selected text down |
| `K` | Move selected text up |

### Auto-completion
| Key | Action |
|-----|--------|
| `Ctrl+Space` | Trigger completion menu |
| `Ctrl+n` | Next suggestion |
| `Ctrl+p` | Previous suggestion |
| `Enter` | Accept suggestion |
| `Tab` | Jump to next snippet placeholder |

---

## Claude Code Integration

| Key | Action |
|-----|--------|
| `<leader>oa` | Ask Claude about this (@this:) |
| `<leader>os` | Select Claude prompt template |
| `<leader>ot` | Toggle Claude Code panel |
| `<leader>oc` | Custom Claude prompt |

Works in both normal and visual mode.

---

## Markdown

| Key | Action |
|-----|--------|
| `<leader>mp` | Toggle markdown preview in browser |

Markdown files automatically get inline rendering with render-markdown.nvim.

---

## C/C++ Development

### Header/Implementation Switching (clangd)
| Key | Action |
|-----|--------|
| `,h` | Switch between header and implementation (same window) |
| `,vh` | Open header/impl in vertical split (side-by-side) |
| `,sh` | Open header/impl in horizontal split (top/bottom) |
| `,th` | Open header/impl in new tab |

**Quick Guide**: Working with .h/.cpp files:
- Same file? Use `,h` to toggle
- Side-by-side? Use `,vh` for vertical split
- Top/bottom? Use `,sh` for horizontal split
- Separate tabs? Use `,th` for new tab

### C++ Symbol Navigation
| Key | Action |
|-----|--------|
| `,si` | Symbol info (templates, overloads) |
| `,ty` | Type hierarchy |
| `gd` | Go to definition (LSP) |
| `gr` | Go to references (LSP) |
| `K` | Show hover documentation (LSP) |

### CMake Integration
| Key | Action |
|-----|--------|
| `<leader>cg` | CMake Generate |
| `<leader>cb` | CMake Build |
| `<leader>cr` | CMake Run |
| `<leader>cd` | CMake Debug |
| `<leader>ct` | CMake Select Build Type |
| `<leader>cc` | CMake Clean |

### Debugging (DAP)
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue execution |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Toggle REPL |
| `<leader>dl` | Run last debug session |
| `<leader>dt` | Terminate debug session |
| `<leader>du` | Toggle DAP UI |

---

## LSP (Language Server Protocol)

These work in any file with LSP support (C++, Rust, TypeScript, etc.)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format file/selection |
| `[d` | Go to previous diagnostic |
| `]d` | Go to next diagnostic |
| `<leader>q` | Open diagnostic list |

---

## Git Integration (gitsigns)

| Key | Action |
|-----|--------|
| `]c` | Next hunk (git change) |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

---

## Treesitter Text Objects

### Select
| Key | Action |
|-----|--------|
| `af` | Select outer function |
| `if` | Select inner function |
| `ac` | Select outer class |
| `ic` | Select inner class |
| `aa` | Select outer parameter |
| `ia` | Select inner parameter |

### Navigate
| Key | Action |
|-----|--------|
| `]f` | Next function start |
| `]F` | Next function end |
| `]c` | Next class start |
| `]C` | Next class end |
| `[f` | Previous function start |
| `[F` | Previous function end |
| `[c` | Previous class start |
| `[C` | Previous class end |

### Incremental Selection
| Key | Action |
|-----|--------|
| `Ctrl+Space` | Init/increment selection |
| `Backspace` | Decrement selection (in visual mode) |

---

## Plugin Management (Lazy)

| Command | Action |
|---------|--------|
| `:Lazy` | Open Lazy plugin manager |
| `:Lazy sync` | Install/update/clean plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy update` | Update plugins |

---

## Useful LazyVim Defaults

### UI
| Key | Action |
|-----|--------|
| `<leader>uD` | Toggle dim (unfocused window dimming) |
| `<leader>ul` | Toggle line numbers |
| `<leader>ur` | Toggle relative line numbers |
| `<leader>uw` | Toggle word wrap |

### Search/Replace
| Key | Action |
|-----|--------|
| `<leader>sr` | Search and replace (grug-far) |
| `<leader>/` | Grep in current directory |

### Misc
| Key | Action |
|-----|--------|
| `<leader>qq` | Quit all |
| `<leader>l` | Lazy plugin manager |
| `<leader>:` | Command history |

---

## Tips

1. **Which-key**: Press `<leader>` and wait to see available keybindings
2. **Telescope**: Most Telescope pickers support:
   - `Ctrl+j/k` to navigate
   - `Ctrl+u/d` to scroll preview
   - `Enter` to select
   - `Esc` to close
3. **LSP**: Hover over errors/warnings and press `K` for details
4. **DAP**: Set breakpoints with `<leader>db`, then start with `<leader>dc`
5. **File type detection**: Run `:set filetype?` to check if syntax highlighting should work

---

## Configuration Files

- General keymaps: `~/.dotfiles/nvim/lua/config/keymaps.lua`
- Plugin-specific: `~/.dotfiles/nvim/lua/plugins/*.lua`
- C/C++ specific: `~/.dotfiles/nvim/lua/plugins/languages/cpp.lua`
- Leader key: `~/.dotfiles/nvim/lua/config/options.lua`

---

**Last updated**: 2025-10-19
