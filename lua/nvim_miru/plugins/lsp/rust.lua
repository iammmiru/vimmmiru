local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config")
return {
	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		lazy = false, -- This plugin is already lazy
		server = {
			on_attach = function(client, buffer)
				lsp_attach.lsp_attach(client, buffer)
				vim.cmd.RustLsp('flyCheck')
			end,
			default_settings = {
				["rust-analyzer"] = {
					checkOnSave = false,
					files = {
						excludeDirs = { "/Users/mirulee/.cargo/", "/Users/mirulee/.rustup/" },
					},
				}
			}
		}
	},
	{
		'saecki/crates.nvim',
		tag = 'stable',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup {
				completion = {
					cmp = {
						enabled = true,
					},
				}
			}
		end,
		lsp = {
			enabled = true,
			on_attach = lsp_attach.lsp_attach,
			actions = true,
			completion = true,
			hover = true,
		},
	}
}
