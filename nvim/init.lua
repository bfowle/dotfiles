-- Set leader keys FIRST (required by lazy.nvim to register keymaps correctly)
-- We also override LazyVim's options.lua (see nvim/lua/lazyvim/config/options.lua)
-- to prevent LazyVim from changing leader to space during initialization
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Disable relative line numbers (override LazyVim default)
vim.opt.relativenumber = false

-- load options before lazy for proper plugin detection
require("config.options")

-- setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import LazyVim
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import LazyVim extras
    { import = "lazyvim.plugins.extras.coding.nvim-cmp" }, -- Use nvim-cmp instead of blink.cmp
    { import = "lazyvim.plugins.extras.lang.markdown" },
    -- NOTE: clangd extra auto-loads when opening C++ files, we override it in cpp.lua
    -- import custom plugins
    { import = "plugins" },
    { import = "plugins.languages" }, -- Language-specific configurations
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Note: We no longer need to set leader AFTER lazy.setup() because we override
-- LazyVim's options.lua (see nvim/lua/lazyvim/config/options.lua) which prevents
-- LazyVim from changing leader to space during initialization

-- load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")
