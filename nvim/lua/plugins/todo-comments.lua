-- Override todo-comments.nvim keybindings
-- Move TODO navigation to ]T/[T to free up ]t/[t for tab navigation
return {
  {
    "folke/todo-comments.nvim",
    keys = {
      -- Explicitly disable LazyVim's default ]t/[t keys
      { "]t", false },
      { "[t", false },
      -- Use capital T for TODO navigation instead
      { "]T", function() require("todo-comments").jump_next() end, desc = "Next TODO Comment" },
      { "[T", function() require("todo-comments").jump_prev() end, desc = "Previous TODO Comment" },
      -- Keep the rest of LazyVim's todo-comments keys
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
}
