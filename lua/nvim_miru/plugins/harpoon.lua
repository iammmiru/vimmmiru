return {
	{
		'theprimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			local mark = require("harpoon.mark")
			local ui   = require("harpoon.ui")

			vim.keymap.set("n", "<C-e>a", mark.add_file)
			vim.keymap.set("n", "<C-e>e", ui.toggle_quick_menu)

			vim.keymap.set("n", "<C-e>1", function() ui.nav_file(1) end)
			vim.keymap.set("n", "<C-e>2", function() ui.nav_file(2) end)
			vim.keymap.set("n", "<C-e>3", function() ui.nav_file(3) end)
			vim.keymap.set("n", "<C-e>4", function() ui.nav_file(4) end)
		end,
	}
}
