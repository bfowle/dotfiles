-- Web development plugins (HTML, CSS, Tailwind, Vue, React)
return {
  -- Tailwind CSS IntelliSense
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    opts = {},
  },

  -- Emmet for HTML/CSS
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-e>"
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
      }
    end,
  },

  -- Auto close and rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- CSS color preview
  {
    "NvChad/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript", "typescript", "vue" },
    opts = {
      filetypes = { "css", "scss", "html", "javascript", "typescript", "vue" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,
      },
    },
  },
}
