return {
	{
		dir = "~/my_project/nvim_plugins/diagpang.nvim",
		config = function()
			local diagpang = require("diagpang")

			vim.keymap.set("n", "]p", function() diagpang.jump({count = 1}) end, { desc = "DiagPang: Next Diagnostic" })
			vim.keymap.set("n", "[p", function() diagpang.jump({count = -1}) end, { desc = "DiagPang: Prev Diagnostic" })
		end
	}
}
