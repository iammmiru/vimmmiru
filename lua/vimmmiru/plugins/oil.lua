---@diagnostic disable: undefined-doc-name
return {
	'stevearc/oil.nvim',
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		columns = {
			"icon",
			-- "permissions",
			"size",
			"mtime",
		},
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				-- hide .DS_Store
				local m = name:match("^%.DS_Store$")
				return m ~= nil
			end
		},
		keymaps = {
			["`"] = false,
			["cd"] = { "actions.cd", mode = "n" }
		}
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function(_, opts)
		require("oil").setup(opts)
		-- -- Keymaps
		vim.keymap.set("n", "<leader>ex", "<cmd>Oil<cr>", { desc = "Open Oil" })
	end,
}
