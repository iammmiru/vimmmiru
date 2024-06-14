return {
	{
		'lewis6991/gitsigns.nvim',
		commit = "4a143f13e122ab91abdc88f89eefbe70a4858a56",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		}
	}
}
