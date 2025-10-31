# C/C++ Development Workflow in Neovim

Modern IDE-like workflow for C/C++ development using Neovim, replacing Visual Studio functionality.

## Features

### ✅ Already Configured (via clangd LSP)
- Code completion with function signatures
- Go to definition/declaration (`gd`, `gD`)
- Find references (`gr`)
- Hover documentation (`K`)
- Code actions (`<leader>ca`)
- Rename refactoring (`<leader>rn`)
- Format code (`<leader>f`)
- Diagnostics navigation (`[d`, `]d`)

### 🆕 C/C++ Specific Features

## Header/Implementation Switching

**Quick Toggle** (same window):
```
,h            - Switch between .h/.hpp and .c/.cpp
```

**Side-by-Side Editing** (like VS split view):
```
,vh           - Open header/impl in vertical split (side-by-side)
,sh           - Open header/impl in horizontal split (top/bottom)
```

**Separate Tabs** (like VS tabs):
```
,th           - Open header/impl in new tab
```

**Example Workflows:**

**Workflow 1: Quick Toggle (same window)**
1. Open `Foo.cpp`
2. Press `,h` → Switches to `Foo.h` in same window
3. Press `,h` again → Back to `Foo.cpp`

**Workflow 2: Side-by-Side (split view)**
1. Open `Foo.cpp`
2. Press `,vh` → Opens `Foo.h` in split on right
3. Edit both files side-by-side
4. Press `Ctrl+w h/l` to navigate between splits

**Workflow 3: Tabs (like Visual Studio)**
1. Open `Foo.cpp`
2. Press `,th` → Opens `Foo.h` in new tab
3. Use `]t` or `[t` to switch between tabs (NO comma prefix!)
4. Or use native vim: `gt` (next tab) / `gT` (previous tab)

## Split Window Management

**Navigate between splits:**
```
Ctrl+w h      - Move to left split
Ctrl+w j      - Move to bottom split
Ctrl+w k      - Move to top split
Ctrl+w l      - Move to right split

Or use configured mappings:
<C-h/j/k/l>   - Quick navigation (if configured in keymaps)
```

**Resize splits:**
```
Ctrl+w =      - Make splits equal size
Ctrl+w _      - Maximize height
Ctrl+w |      - Maximize width
Ctrl+w >      - Increase width
Ctrl+w <      - Decrease width
```

**Close splits:**
```
:q            - Close current split
:only         - Close all splits except current
```

## CMake Integration

**Build commands:**
```
<leader>cg    - CMake Generate (configure)
<leader>cb    - CMake Build
<leader>cr    - CMake Run
<leader>ct    - CMake Select Build Type (Debug/Release)
<leader>cc    - CMake Clean
```

**Typical workflow:**
```bash
# First time setup
<leader>cg    # Generate build files
<leader>ct    # Select Debug or Release
<leader>cb    # Build project
<leader>cr    # Run executable
```

## Debugging (GDB/LLDB Integration)

**Debugger controls:**
```
<leader>db    - Toggle breakpoint
<leader>dc    - Continue/Start debugging
<leader>di    - Step into
<leader>do    - Step over
<leader>dO    - Step out
<leader>dt    - Terminate debugging
<leader>du    - Toggle debug UI
<leader>dr    - Toggle REPL/console
```

**Debug workflow:**
1. Open your source file
2. Set breakpoints: `<leader>db` on desired lines
3. Start debugging: `<leader>dc`
4. Debug UI opens automatically with:
   - Variable scopes
   - Call stack
   - Breakpoints list
   - Watch expressions
   - Console/REPL
5. Step through code: `<leader>di/do/dO`
6. Stop debugging: `<leader>dt`

## Additional C/C++ Features

**Symbol information:**
```
,si           - Show detailed symbol info (useful for templates)
,ty           - Show type hierarchy (class inheritance)
```

**Project navigation:**
```
<C-p>         - Find files (Telescope)
<leader>fg    - Live grep (search in files)
<leader>fb    - Browse buffers
```

## Example: Typical C++ Project Workflow

### 1. Opening a project:
```bash
cd ~/projects/myapp
nvim .
```

### 2. Navigate to files:
- Press `<C-p>` → type filename → Enter

### 3. Work on class implementation:

**Option A: Split view (side-by-side)**
```
# In MyClass.cpp
,vh           # Open MyClass.h in vertical split
              # Now edit both side-by-side
```

**Option B: Tabs (like Visual Studio)**
```
# In MyClass.cpp
,th           # Open MyClass.h in new tab
]t or [t      # Switch between tabs (no comma!)
```

**Option C: Quick toggle (same window)**
```
# In MyClass.cpp
,h            # Switch to MyClass.h
,h            # Back to MyClass.cpp
```

### 4. Build and run:
```
<leader>cb    # Build
<leader>cr    # Run
```

### 5. Debug issues:
```
<leader>db    # Set breakpoint on problematic line
<leader>dc    # Start debugging
<leader>di    # Step through code
<leader>du    # Close debug UI when done
```

### 6. Code navigation:
```
K             # Hover over function to see docs
gd            # Go to definition
gr            # Find all references
<leader>rn    # Rename symbol across project
```

## Tips & Tricks

### Multi-file editing:
```
# Open multiple files in splits
:vsplit file1.cpp
:split file2.cpp

# Or use tabs
:tabnew file1.cpp
gt/gT to switch tabs
```

### Quick build from any file:
```
:!make
:!cmake --build build
:terminal  # Open terminal in split for compilation
```

### Search across project:
```
<leader>fg    # Live grep
              # Type your search term
              # Preview results in real-time
```

### Include file navigation:
- Put cursor on `#include "MyHeader.h"`
- Press `gf` → Opens MyHeader.h

## Comparison with Visual Studio

| Visual Studio Feature | Neovim Equivalent |
|----------------------|-------------------|
| Solution Explorer | `<C-p>` (Telescope) |
| Go to Definition | `gd` |
| Find All References | `gr` |
| Switch Header/Source | `<leader>h` or `<leader>vh` |
| Build Solution | `<leader>cb` |
| Start Debugging | `<leader>dc` |
| Toggle Breakpoint | `<leader>db` |
| Step Into/Over/Out | `<leader>di/do/dO` |
| Rename Symbol | `<leader>rn` |
| Quick Info | `K` |
| IntelliSense | Automatic (via clangd) |

## Installation Notes

All features are automatically installed when you run `./install.sh`. The following plugins provide the functionality:

- **neovim-cmake** - CMake integration
- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - Visual debugging interface
- **nvim-dap-virtual-text** - Inline variable values while debugging
- **clangd** - Language server (via LSP)
- **Telescope** - Fuzzy finder

## Requirements

For full functionality, ensure these are installed:
```bash
# LSP (already installed via install.sh)
clangd

# Build tools
cmake
make
gcc/g++ or clang

# Debugging (optional)
gdb
# or
lldb
```

## Customization

All C/C++ specific settings are in:
- `/home/brett/.dotfiles/nvim/lua/plugins/languages/cpp.lua`

Modify keymaps or add features by editing this file.

## Troubleshooting

### Leader Key Shows as Space Instead of Comma

**Symptom**: Pressing `,` (comma) doesn't trigger leader keymaps, or which-key shows ` ` (space) instead of `,`

**Cause**: The leader key change in init.lua requires a FULL nvim restart (not just `:source`)

**Solution**:
1. **Close ALL nvim instances completely** (not just `:q`, but close terminal/window)
2. **Open fresh nvim**
3. **Verify**: Run `:echo mapleader` - should show `,` not ` `
4. **Test**: Press `,` and wait - should see which-key popup

**Note**: If leader still shows space:
- Check `nvim/init.lua` lines 3 and 61 both set `vim.g.mapleader = ","`
- Make sure no other plugin is overriding it

### "Corresponding File Cannot Be Determined" in Unreal Engine

**Symptom**: `,h`, `,vh`, `,sh`, `,th` show this error instead of switching to header

**Cause**: clangd doesn't know about Unreal Engine's Public/Private folder structure

**Solutions**:

**✅ FIXED for WSL Users:**
If you have `compile_commands.json` but header switching still doesn't work in WSL:
- **Cause**: compile_commands.json uses Windows paths (`C:/Users/...`) but clangd uses WSL paths (`/mnt/c/Users/...`)
- **Solution**: Already applied! We added `--path-mappings=C:=/mnt/c` to clangd
- **Restart nvim** to apply the fix

**If you don't have compile_commands.json yet:**
Generate it in your Unreal project:
```bash
cd /mnt/c/Users/brett/Projects/Wyrmrest  # or your project path

# UE5 with UnrealBuildTool
UnrealBuildTool -mode=GenerateClangDatabase \
  -project="Wyrmrest.uproject" -game -engine

# Or for UE4
UnrealBuildTool -mode=GenerateClangDatabase \
  -project="YourProject.uproject" \
  YourTargetEditor Development Win64
```

This generates `compile_commands.json` which tells clangd exactly where all files are.

**Manual navigation (if compile_commands.json doesn't work):**
- Use `gd` (go to definition) to navigate to headers
- Use `<C-p>` (Telescope) to find files by name
- Use `<leader>fg` to grep for the filename

**Note**: The .clangd config at `/mnt/c/Users/brett/Projects/Wyrmrest/.clangd` suppresses errors but doesn't fix header switching. The compile_commands.json + path-mappings is what makes header switching work.

### Keybinding Conflicts (RESOLVED)

**Issue**: `,th` didn't work, and `]t`/`[t` showed "No more todo comments"

**Cause**:
- LazyVim's clangd extras defined `,ch` for header switching
- todo-comments.nvim plugin used `]t`/`[t` for TODO navigation

**Solution** (already applied):
- Disabled LazyVim's `,ch` - now use our custom `,h`, `,vh`, `,sh`, `,th`
- Moved TODO navigation to capital `]T`/`[T`
- Tab navigation now works with `]t`/`[t` (no comma prefix!)

### clangd Errors in Unreal Engine Projects

**Error**: `-32602: trying to get AST for non-added document`

**Cause**: clangd doesn't have compilation information for Unreal Engine projects.

**Solution**: Create a `.clangd` config file in your project root:

```bash
# Copy the template to your Unreal project
cp ~/.dotfiles/.claude/templates/unreal-clangd-config /path/to/YourProject/.clangd
```

This will:
- Suppress common Unreal Engine warnings
- Set appropriate C++ standard (C++17/20)
- Reduce diagnostic noise

**Alternative**: Generate `compile_commands.json` for full IntelliSense:
```bash
# In your Unreal project directory
UnrealBuildTool -mode=GenerateClangDatabase -project="YourProject.uproject" -game -engine
```

### Header/Implementation Switching Not Working

Make sure:
1. File follows Unreal convention: `MyClass.h` in Public/, `MyClass.cpp` in Private/
2. Or files are in same directory
3. Run `:LspInfo` to verify clangd is running

### Debugging Not Working

1. Ensure `gdb` or `lldb` is installed
2. Compile with debug symbols: `cmake -DCMAKE_BUILD_TYPE=Debug`
3. Check DAP configuration in `cpp.lua`
