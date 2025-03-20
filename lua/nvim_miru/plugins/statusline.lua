return {
	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_x = { 'encoding', 'fileformat', 'filetype', { 'searchcount', maxcount = 100000, timeout = 500 } }
			}
		}
	}
}
