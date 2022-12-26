-- vim.cmd[[set t_Co=256]]
vim.cmd [[set cursorline]]
vim.cmd.colorscheme("seoulbones")
vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
vim.cmd [[hi LineNr guibg=NONE ctermbg=NONE]]
vim.cmd [[hi NonText guibg=NONE ctermbg=NONE]]
vim.cmd [[hi EndOfBuffer guibg=NONE ctermbg=NONE]]
vim.keymap.set("n", "<leader>bt", ':exec &bg=="light"? "set bg=dark" : "set bg=light"<CR>',
    { noremap = true, silent = true, desc = "[B]ackground color [T]oggle" })
