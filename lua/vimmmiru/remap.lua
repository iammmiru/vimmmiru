vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+yg_]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["+d]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Paste from clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd> ToggleTerm direction=float<CR>", { desc = "Toggle terminal float" })
-- vim.keymap.set({ "n", "t" }, "<C-\\>h", "<cmd> ToggleTerm direction=horizontal<CR>",
--     { desc = "Toggle terminal horizontal" })
-- vim.keymap.set({ "n", "t" }, "<C-\\>v", "<cmd> ToggleTerm direction=vertical<CR>", { desc = "Toggle terminal vertical" })


-- Switching between buffers
vim.keymap.set('n', '<C-l>', '<cmd> bnext <cr>')
vim.keymap.set('n', '<C-h>', '<cmd> bprevious <cr>')

vim.keymap.set('n', '<C-n>', '<cmd>cnext<cr>zz', { silent = true, desc = "Move to next in quickifx list" })
vim.keymap.set('n', '<C-p>', '<cmd>cprev<cr>zz', { silent = true, desc = "Move to prev in quickifx list" })

-- Unmap some annoying behaviors
vim.keymap.set("n", "L", "<nop>")
vim.keymap.set("n", "H", "<nop>")
vim.keymap.set("n", "J", "<nop>")
vim.keymap.set({ "n", "t", "i", "v" }, "<C-w>q", "<nop>")
vim.keymap.set({ "n", "t", "i", "v" }, "<C-w><C-q>", "<nop>")

-- remove search highlight
vim.keymap.set("n", "<leader>n", "<cmd>noh<CR>", { desc = "Remove search highlight" })

vim.keymap.set({ "n", "v" }, "<C-s>", "<C-a>", { silent = true })
vim.keymap.set({ "n", "v" }, "g<C-s>", "g<C-a>", { silent = true })

-- copy current directory path to clipboard
vim.keymap.set("n", "cd", ":let @+ = expand('%')<CR>", { silent = true, desc = "Copy the current directory path to clipboard"})

-- remove keymaps that'll be replaced by LSP keymap
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gri")
vim.keymap.del({"n", "x"}, "gra")
