return {
	{
		'lewis6991/gitsigns.nvim',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
		on_attach = {
			on_attach = function(bufnr)
				if vim.bo[bufnr].filetype == "netrw" then return false end
			end,
		}
	}
}
