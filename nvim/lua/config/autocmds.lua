-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Jump to last cursor position when opening a file
autocmd("BufReadPost", {
  group = augroup("LastPosition", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto create parent directories when saving a file
autocmd("BufWritePre", {
  group = augroup("AutoCreateDir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Force disable relative line numbers (override LazyVim default)
autocmd("VimEnter", {
  group = augroup("DisableRelativeNumber", { clear = true }),
  callback = function()
    vim.opt.relativenumber = false
    vim.opt.number = true
  end,
})

-- Also disable relative numbers when entering any buffer
autocmd("BufEnter", {
  group = augroup("DisableRelativeNumberBuf", { clear = true }),
  callback = function()
    vim.opt.relativenumber = false
  end,
})

-- Fix lazy.nvim float buffer errors on window resize
autocmd("VimResized", {
  group = augroup("FixLazyResize", { clear = true }),
  callback = function()
    -- Save current tab before resizing
    local current_tab = vim.fn.tabpagenr()
    -- Safely resize all windows, catching any invalid buffer errors
    pcall(function()
      vim.cmd("tabdo wincmd =")
    end)
    -- Restore original tab (tabdo leaves you on the last tab)
    pcall(function()
      vim.cmd("tabn " .. current_tab)
    end)
  end,
})
