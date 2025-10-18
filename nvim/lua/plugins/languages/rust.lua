-- Rust-specific plugins and configuration
return {
  -- Crates.nvim - manage Cargo dependencies
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      })

      -- Crates keymaps
      vim.keymap.set("n", "<leader>ct", "<cmd>lua require('crates').toggle()<cr>", { desc = "Toggle crates" })
      vim.keymap.set("n", "<leader>cr", "<cmd>lua require('crates').reload()<cr>", { desc = "Reload crates" })
      vim.keymap.set("n", "<leader>cv", "<cmd>lua require('crates').show_versions_popup()<cr>", { desc = "Show versions" })
      vim.keymap.set("n", "<leader>cf", "<cmd>lua require('crates').show_features_popup()<cr>", { desc = "Show features" })
      vim.keymap.set("n", "<leader>cu", "<cmd>lua require('crates').update_crate()<cr>", { desc = "Update crate" })
      vim.keymap.set("v", "<leader>cu", "<cmd>lua require('crates').update_crates()<cr>", { desc = "Update crates" })
      vim.keymap.set("n", "<leader>cU", "<cmd>lua require('crates').upgrade_crate()<cr>", { desc = "Upgrade crate" })
      vim.keymap.set("v", "<leader>cU", "<cmd>lua require('crates').upgrade_crates()<cr>", { desc = "Upgrade crates" })
    end,
  },

  -- Rustaceanvim - better rust-analyzer integration
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Rust-specific keymaps
            vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", { buffer = bufnr, desc = "Rust debuggables" })
            vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", { buffer = bufnr, desc = "Rust runnables" })
            vim.keymap.set("n", "<leader>rt", "<cmd>RustLsp testables<cr>", { buffer = bufnr, desc = "Rust testables" })
            vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", { buffer = bufnr, desc = "Expand macro" })
            vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", { buffer = bufnr, desc = "Open Cargo.toml" })
            vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", { buffer = bufnr, desc = "Parent module" })
            vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", { buffer = bufnr, desc = "Hover actions" })
          end,
        },
      }
    end,
  },
}
