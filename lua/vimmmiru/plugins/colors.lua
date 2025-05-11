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
						["NormalFloat"] = { bg = "NONE" },
						["FloatBorder"] = { bg = "NONE" },
						["Pmenu"] = { bg = "NONE" },
						["Constant"] = { fg = teal.dim },
						["Visual"] = { bg = palette.black.bright },
					}
				},
				palettes = {
					nordfox = {
						comment = "#728f97",
					},
				}
			})

			vim.cmd("colorscheme nordfox")
			-- vim.cmd [[hi NormalFloat guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi FloatBorder guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi LineNr guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi NonText guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi EndOfBuffer guibg=NONE ctermbg=NONE]]
			-- vim.cmd [[hi NormalColor ctermbg=NONE ctermfg=NONE]]

			-- vim.cmd [[hi Cursorline guibg=#314557]]
			-- vim.cmd [[hi Comment guifg=#728f96]]
			-- local lush = require("lush")
			-- local base = require("zenbones")
			-- local specs = lush.parse(function()
			-- 	return {
			-- 		Boolean { base.Boolean, fg = "#ecf7b3" }
			-- 	}
			-- end)
			-- lush.apply(lush.compile(specs))
		end,
	},
}
