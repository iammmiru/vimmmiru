return {
	{
		"mcchrish/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		config = function()
			vim.opt.cursorline = true
			vim.opt.cursorcolumn = true
			vim.cmd.colorscheme("seoulbones")
			vim.cmd [[hi IncSearch guibg=teal guifg=reverse]]
			vim.cmd [[hi Search guibg=teal]]
			vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
			vim.cmd [[hi LineNr guibg=NONE ctermbg=NONE]]
			vim.cmd [[hi NonText guibg=NONE ctermbg=NONE]]
			vim.cmd [[hi EndOfBuffer guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi Cursorline guibg=#3e585e]]
			-- vim.cmd [[hi comment guifg=#728f96]]
			-- vim.cmd [[hi NormalColor ctermbg=NONE ctermfg=NONE]]
			-- vim.opt.laststatus=2
			-- vim.opt.statusline=
			-- vim.cmd [[set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}]]
			vim.keymap.set("n", "<leader>bt", ':exec &bg=="light"? "set bg=dark" : "set bg=light"<CR>',
			    { noremap = true, silent = true, desc = "[B]ackground color [T]oggle" })
			end,
	},
}
