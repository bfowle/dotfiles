-- Core plugins and customizations
return {
  -- Disable bufferline (LazyVim default that shows buffers as tabs)
  -- Use traditional vim buffer management with :ls, :b, etc.
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- Better escape (updated API after rewrite)
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 200, -- Time in ms to wait for the second key
      default_mappings = true, -- Use default jk mapping
      mappings = {
        i = {
          j = {
            k = "<Esc>", -- jk in insert mode
            j = "<Esc>", -- jj in insert mode
          },
        },
      },
    },
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
