vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.guicursor = "n-c-v:block-nCursor"
-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.o.completeopt = 'menuone,noinsert,noselect,preview'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 1000

vim.opt.textwidth = 80
vim.opt.wrapmargin = 80
vim.opt.wrap = true
vim.opt.linebreak = true

vim.o.title = true
-- vim.cmd [[set titlestring=%F\ \ %{strftime('%d.%m.%Y\ %H:%M',getftime(expand('%')))}]]
vim.cmd([[set titlestring=%t]])

-- Update the contents that are modified out side of vim.
-- The update happens through calling checktime, which is
-- triggered whenever the terminal gets a focus.
vim.cmd([[au FocusGained,BufEnter * checktime]])
-- turning on relative line numbers in netrw
vim.g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"

-- turn on spell check
vim.cmd([[set spell spelllang=en_us]])

-- turn off crappy search count
vim.cmd([[set shortmess+=S]])
