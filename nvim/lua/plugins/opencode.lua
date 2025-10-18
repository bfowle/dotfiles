-- opencode.nvim - Claude Code integration
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
  },
  config = function()
    -- Enable auto reload for opencode edits
    vim.opt.autoread = true

    -- Keymaps for Claude Code integration
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask Claude about this" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select Claude prompt" })

    vim.keymap.set({ "n", "x" }, "<leader>ot", function()
      require("opencode").toggle()
    end, { desc = "Toggle Claude Code" })

    vim.keymap.set({ "n", "x" }, "<leader>oc", function()
      require("opencode").ask("", { submit = false })
    end, { desc = "Custom Claude prompt" })
  end,
}
