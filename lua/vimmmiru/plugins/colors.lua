return {
	{
		"EdenEast/nightfox.nvim",
		config = function()
			vim.opt.cursorline = true
			vim.opt.cursorcolumn = true

			local palette = require("nightfox.palette").load("nordfox")

			local Shade = require("nightfox.lib.shade")
			local teal = Shade.new("#42a89a", "#7fc7bd", "#0cbec4")

			require("nightfox").setup({
				options = {
					transparent = true,
					colorblind = {
						enable = true,
						simulate_only = false,
						severity = {
							protan = 0.6,
							deutan = 1.0,
							tritan = 0.3,
						},
					},
				},
				groups = {
					nordfox = {
						["@function.builtin"] = { link = "@function" },
						["@function"] = { fg = palette.yellow },
						["Type"] = { fg = teal.bright },
						["@property"] = { fg = palette.blue.bright },
						["String"] = { fg = palette.green.bright },
						["Constant"] = { fg = teal.dim },
						["Visual"] = { bg = palette.black.bright },
					}
				},
				palettes = {
					nordfox = {
						comment = "#728f97",
						white = palette.white.dim,
					},
				}
			})

			vim.cmd("colorscheme nordfox")
		end,
	},
}
