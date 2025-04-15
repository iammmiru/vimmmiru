local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config")
return {
	{
		'mrcjkb/rustaceanvim',
		version = '^6', -- Recommended
		lazy = false, -- This plugin is already lazy
		init = function()
			vim.g.rustaceanvim = {
				server = {
					capabilities = require('cmp_nvim_lsp').default_capabilities(),
					on_attach = function(client, buffer)
						lsp_attach.lsp_attach(client, buffer)
					end,
					default_settings = {
						["rust-analyzer"] = {
							checkOnSave = true,
							files = {
								-- excludeDirs = { "/Users/mirulee/.cargo/", "/Users/mirulee/.rustup/" },
							},
						}
					}
				}
			}
		end
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
