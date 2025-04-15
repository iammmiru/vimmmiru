local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config")
return {
	{
		'mrcjkb/rustaceanvim',
		version = '^6', -- Recommended
		lazy = false, -- This plugin is already lazy
		init = function()
			vim.g.rustaceanvim = {
				tools = {
					float_win_config = {
						border = "rounded", max_width = 120,
					},
				},
				server = {
					capabilities = require('cmp_nvim_lsp').default_capabilities(),
					on_attach = function(client, bufnr)
						lsp_attach.lsp_attach(client, bufnr)

						vim.keymap.set(
							"n",
							"<leader>ca",
							function()
								vim.cmd.RustLsp('codeAction')
							end,
							{ silent = true, buffer = bufnr }
						)
						vim.keymap.set(
							"n",
							"<leader>ce",
							function()
								vim.cmd.RustLsp('explainError', 'cycle')
							end,
							{ silent = true, buffer = bufnr }
						)
						vim.keymap.set(
							"n",
							"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
							function()
								vim.cmd.RustLsp({ 'hover', 'actions' })
							end,
							{ silent = true, buffer = bufnr }
						)
						vim.keymap.set(
							"n",
							"<leader>rt",
							function()
								vim.cmd.RustLsp({ 'run' })
							end,
							{ silent = true, buffer = bufnr }
						)
						vim.keymap.set(
							"n",
							"<leader>ra",
							function()
								vim.cmd.RustLsp({ 'runnables' })
							end,
							{ silent = true, buffer = bufnr }
						)

						for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
							local default_diagnostic_handler = vim.lsp.handlers[method]
							vim.lsp.handlers[method] = function(err, result, context, config)
								if err ~= nil and err.code == -32802 then
									return
								end
								return default_diagnostic_handler(err, result, context, config)
							end
						end
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
