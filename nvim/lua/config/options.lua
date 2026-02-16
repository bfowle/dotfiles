-- Options
local opt = vim.opt

-- Enable filetype detection (critical for syntax highlighting)
vim.cmd("filetype plugin indent on")

-- Note: Leader key is set in init.lua in TWO places:
--   1. Before lazy.setup() (line 3-4) - reduces warnings
--   2. After lazy.setup() (line 59-60) - actually works (LazyVim overrides during load)
-- Do NOT set it here - options.lua loads during lazy.setup(), won't stick

-- General
opt.number = true -- show line numbers
opt.relativenumber = false -- disable relative line numbers
opt.cursorline = true -- highlight current line
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.encoding = "utf-8"
opt.autoread = true -- auto reload files changed outside of vim (required for opencode)

-- Backup and swap files
opt.backup = false
opt.writebackup = false
opt.swapfile = true
opt.directory = vim.fn.expand("~/.vim/tmp//")
opt.backupdir = vim.fn.expand("~/.vim/tmp//")

-- Tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- always show sign column
opt.scrolloff = 8 -- keep 8 lines above/below cursor
opt.sidescrolloff = 8
opt.colorcolumn = "120"

-- Split windows
opt.splitbelow = true
opt.splitright = true

-- Misc
opt.formatoptions:remove("o") -- don't add comment prefix when opening new lines
opt.mouse = "a" -- enable mouse support
opt.updatetime = 300 -- reduce LSP update frequency to prevent lag (default: 250)
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000

-- Performance optimizations
opt.synmaxcol = 300 -- only highlight first 300 columns (prevents lag on long lines)
-- Note: lazyredraw disabled - it prevents visual feedback during repeated operations (indenting, etc.)
-- Note: redrawtime uses default (2000ms) for complete syntax highlighting
