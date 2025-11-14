-- Code formatting with conform.nvim
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },

        -- Web
        vue = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        jsonc = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },

        -- Rust
        rust = { "rustfmt" },

        -- Go
        go = { "goimports", "gofmt" },

        -- C/C++
        c = { "clang_format" },
        cpp = { "clang_format" },

        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "black" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      -- NOTE: Don't set format_on_save here - LazyVim handles it via autocmd
      -- Use LazyVim.format.enabled() to toggle instead

      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        -- Ensure clang-format uses .clang-format file from project/home
        clang_format = {
          args = { "--style=file", "-assume-filename", "$FILENAME" },  -- Override default args to force reading .clang-format
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Command to toggle format on save
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify("Format on save disabled", vim.log.levels.INFO)
        else
          vim.notify("Format on save enabled", vim.log.levels.INFO)
        end
      end, {
        desc = "Toggle format on save",
      })
    end,
  },
}
