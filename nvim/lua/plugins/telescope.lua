-- Telescope configuration - open files in tabs instead of buffers
return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Override default Ctrl-P to open in tabs
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files({
            attach_mappings = function(_, map)
              -- Default action (Enter) opens in new tab
              map("i", "<CR>", require("telescope.actions").file_tab)
              map("n", "<CR>", require("telescope.actions").file_tab)
              return true
            end,
          })
        end,
        desc = "Find files (open in tabs)",
      },
    },
  },
}
