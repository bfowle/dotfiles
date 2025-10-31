-- Snacks.nvim configuration (LazyVim default plugin)
-- Ensures proper UI hooks are set up
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Core features
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },

      -- UI enhancements
      input = { enabled = true },
      picker = { enabled = true },
      dashboard = { enabled = true },

      -- Terminal
      terminal = { enabled = true },

      -- Git integration
      lazygit = { enabled = true },

      -- File explorer
      explorer = { enabled = true },

      -- Disable visual features that can cause layout issues
      dim = { enabled = false },        -- Disable dimming unfocused windows
      indent = { enabled = false },     -- Disable indent guides (can cause visual artifacts)
      scope = { enabled = false },      -- Disable scope highlighting
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)

      -- Set up UI hooks
      vim.ui.select = snacks.picker.select
      vim.ui.input = snacks.input
    end,
  },
}
