-- TypeScript/JavaScript-specific plugins
return {
  -- TypeScript tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },

  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    config = function()
      require("package-info").setup()

      vim.keymap.set("n", "<leader>ns", "<cmd>lua require('package-info').show()<cr>", { desc = "Show package info" })
      vim.keymap.set("n", "<leader>nc", "<cmd>lua require('package-info').hide()<cr>", { desc = "Hide package info" })
      vim.keymap.set("n", "<leader>nt", "<cmd>lua require('package-info').toggle()<cr>", { desc = "Toggle package info" })
      vim.keymap.set("n", "<leader>nu", "<cmd>lua require('package-info').update()<cr>", { desc = "Update package" })
      vim.keymap.set("n", "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", { desc = "Delete package" })
      vim.keymap.set("n", "<leader>ni", "<cmd>lua require('package-info').install()<cr>", { desc = "Install package" })
      vim.keymap.set("n", "<leader>np", "<cmd>lua require('package-info').change_version()<cr>", { desc = "Change version" })
    end,
  },
}
