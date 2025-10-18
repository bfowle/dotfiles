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
    -- import custom plugins
    { import = "plugins" },
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

-- load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")
