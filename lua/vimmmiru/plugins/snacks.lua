---@diagnostic disable: undefined-global, undefined-doc-name
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		-- explorer = { enabled = false },
		-- indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			focus = "list",
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		-- scroll = { enabled = true },
		statuscolumn = { enabled = true },
		-- words = { enabled = true },
		rename = { enabled = true },

		styles = {
			input = {
				relative = "cursor",
				row = -3,
				col = 0,
			}
		}
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		vim.api.nvim_create_user_command(
			"NotiHistory",
			function() require("snacks").notifier.show_history() end,
			{ desc = "Show Snacks Notifier History" }
		)
	end,
}
