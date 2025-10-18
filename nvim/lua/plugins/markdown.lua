-- Markdown plugins - inline rendering + browser preview
return {
  -- Inline markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
    ft = { "markdown" },
  },

  -- Browser-based markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    event = "VeryLazy", -- Load early to ensure autocmds are set up
    build = "cd app && ./install.sh",
    init = function()
      -- Set global config before plugin loads
      vim.g.mkdp_command_for_global = 1
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_browser = "" -- Use default browser
    end,
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
        ft = "markdown",
      },
    },
  },

  -- Markdown extras from LazyVim
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
}
