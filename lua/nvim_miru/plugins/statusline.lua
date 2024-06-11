return {
	{
		'nvim-lualine/lualine.nvim',
		version = "0a5a66803c7407767b799067986b4dc3036e1983",
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
