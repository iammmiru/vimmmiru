return {
	{
		'windwp/nvim-autopairs',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			fast_wrap = {
				map = '<C-w>'
			}
		}
	}
}
