vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
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
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set("v", '<leader>p', '"+p')
vim.keymap.set("v", '<leader>P', '"+P')

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd> ToggleTerm direction=float<CR>", { desc = "Toggle terminal float" })
-- vim.keymap.set({ "n", "t" }, "<C-\\>h", "<cmd> ToggleTerm direction=horizontal<CR>",
--     { desc = "Toggle terminal horizontal" })
-- vim.keymap.set({ "n", "t" }, "<C-\\>v", "<cmd> ToggleTerm direction=vertical<CR>", { desc = "Toggle terminal vertical" })


-- Switching between buffers
vim.keymap.set('n', '<C-l>', '<cmd> bnext <cr>')
vim.keymap.set('n', '<C-h>', '<cmd> bprevious <cr>')

-- Unmap some annoying behaviors
vim.keymap.set("n", "L", "")
vim.keymap.set("n", "H", "")
vim.keymap.set("n", "J", "")
vim.keymap.set({"n","t","i","v"}, "<C-w>q", "")

-- remove search highlight
vim.keymap.set("n", "<leader>n", "<cmd>noh<CR>", {desc = "Remove search highlight"})
