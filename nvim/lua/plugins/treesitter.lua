-- Treesitter for syntax highlighting
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = function(_, opts)
      -- Extend LazyVim's ensure_installed with our custom parsers
      vim.list_extend(opts.ensure_installed or {}, {
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
      })

      -- Merge our custom configuration with LazyVim's defaults
      opts.auto_install = true
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false
      -- Disable highlighting for large files to prevent lag
      opts.highlight.disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end

      opts.indent = opts.indent or {}
      opts.indent.enable = true
      opts.indent.disable = { "python", "yaml" }

      -- Disable incremental selection for C/C++ to prevent visual mode corruption
      opts.incremental_selection = opts.incremental_selection or {}
      opts.incremental_selection.enable = true
      opts.incremental_selection.disable = { "c", "cpp" }  -- Prevent visual mode bugs in C/C++
      opts.incremental_selection.keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      }

      opts.textobjects = opts.textobjects or {}
      opts.textobjects.select = {
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
      }
      opts.textobjects.move = {
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
      }

      return opts
    end,
  },
}
