-- Treesitter for syntax highlighting
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = {
        -- Core languages
        "lua",
        "vim",
        "vimdoc",
        "query",
        "regex",

        -- Web development
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "json",
        "jsonc",
        "yaml",
        "toml",

        -- Systems programming
        "rust",
        "c",
        "cpp",
        "go",
        "gomod",
        "gowork",
        "gosum",

        -- Shell and config
        "bash",
        "fish",

        -- Markup
        "markdown",
        "markdown_inline",

        -- Version control
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",

        -- Other
        "dockerfile",
        "make",
        "cmake",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        disable = { "python", "yaml" }, -- These can be problematic
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}
