-- Core plugins and customizations
return {
  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      local ok, better_escape = pcall(require, "better_escape")
      if ok then
        better_escape.setup({
          mapping = { "jk", "jj" }, -- Maps jk and jj to <Esc> in insert mode
          timeout = 200, -- Time in ms to wait for the second key
          clear_empty_lines = false,
          keys = "<Esc>",
        })
      else
        vim.notify("Failed to load better-escape: " .. tostring(better_escape), vim.log.levels.ERROR)
      end
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local ok, autopairs = pcall(require, "nvim-autopairs")
      if ok then
        autopairs.setup({
          check_ts = true, -- Use treesitter
          ts_config = {
            lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
            javascript = { "template_string" },
          },
        })
      else
        vim.notify("Failed to load nvim-autopairs: " .. tostring(autopairs), vim.log.levels.ERROR)
      end
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree" },
    },
  },

  -- Fuzzy finder (replaces ctrlp)
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  },

  -- Git integration (like vim-fugitive)
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
  },
}
