-- LSP Configuration for all languages
-- Migrated to LazyVim's opts pattern (no more deprecated lspconfig framework)
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      if not opts.servers then
        opts.servers = {}
      end

      -- LSP server configurations
      -- Each server config is added to opts.servers (LazyVim's pattern)
      local servers = {
        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },

        -- TypeScript/JavaScript
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Vue.js
        vue_ls = {
          filetypes = { "vue", "typescript", "javascript" },
        },

        -- HTML/CSS
        html = {},
        cssls = {},

        -- Tailwind CSS
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },

        -- C/C++ - configured entirely in languages/cpp.lua

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        -- Bash
        bashls = {},

        -- JSON
        jsonls = {},
      }

      -- Merge our server configs into opts.servers (LazyVim's pattern)
      for server_name, config in pairs(servers) do
        opts.servers[server_name] = vim.tbl_deep_extend("force", opts.servers[server_name] or {}, config)
      end

      return opts
    end,
  },

  -- Mason LSP configuration
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Only auto-install servers that are known to work with Mason
      -- Some servers (like vue_ls) are installed globally via npm in install-lsp-servers.sh
      -- Note: clangd is managed by languages/cpp.lua
      ensure_installed = {
        "rust_analyzer",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "gopls",
        "lua_ls",
        "bashls",
        "jsonls",
      },
      automatic_installation = false,
    },
  },

  -- Mason UI
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },

  -- LSP Keymaps (applies to ALL LSP servers)
  -- Uses LazyVim's on_attach system instead of manual per-server setup
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Set up keymaps for all LSP servers using LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        -- LSP keymaps (same as before, but now using LazyVim's system)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        end,
      })
    end,
  },

  -- Diagnostic configuration
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
