-- Options
local opt = vim.opt

-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

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
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
