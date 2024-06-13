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
		commit = "56c684a805fe948936cda0d1b19505b84ad7e065",
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
