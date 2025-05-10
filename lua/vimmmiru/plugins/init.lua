return {
	-- Indent break line
	{
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('ibl').setup {
				indent = { char = "┊" }
			}
		end
	},

	{
		'mbbill/undotree',
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},

	-- Terminal functionalities
	{
		"akinsho/toggleterm.nvim",
		version = '*',
		config = function()
			require("toggleterm").setup()
		end
	},

	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},

	-- CSV plugin
	'chrisbra/csv.vim',
}
