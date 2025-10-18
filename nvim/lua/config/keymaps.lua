-- Keymaps
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Clear search highlighting with Enter
keymap.set("n", "<CR>", ":nohlsearch<CR>", opts)

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Tab navigation
keymap.set("n", "<C-J>", ":tabprevious<CR>", opts)
keymap.set("n", "<C-K>", ":tabnext<CR>", opts)

-- Jump to alternate file (previous buffer)
keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Alternate file" })

-- File operations in current directory
keymap.set("c", "%%", "<C-R>=expand('%:h').'/'<CR>", { noremap = true })
keymap.set("n", "<leader>e", ":edit %%", { desc = "Edit file in current dir" })
keymap.set("n", "<leader>v", ":vsplit %%", { desc = "Vsplit file in current dir" })

-- Whitespace cleanup
keymap.set("n", "<leader>w", ":retab | :%s/\\s\\+$//e<CR>", { desc = "Clean whitespace" })

-- Diff operations
keymap.set("n", "<leader>do", ":only! | :diffoff!<CR>", { desc = "Close other splits & diff off" })

-- Better indenting (stay in visual mode)
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Move text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
