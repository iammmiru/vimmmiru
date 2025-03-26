return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- LSP Support
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_defaults = lspconfig.util.default_config

			lsp_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lsp_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config").lsp_attach

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = "LSP actions",
				callback = function(event)
				lsp_attach(event.client, event.buf)
				end
			})


			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'lua_ls',
					'jdtls',
					'pyright',
					'bashls',
					'yamlls',
					'ruff',
					'rust_analyzer'
				},
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({})
					end,

					rust_analyzer = function() end,

					lua_ls = function()
						lspconfig.lua_ls.setup({
							settings = {
								Lua = {
									diagnostics = {
										globals = { 'vim' }
									}
								}
							}
						})
					end,

					ruff = function()
						lspconfig.ruff.setup({
							init_options = {
								settings = {
									args = {},
								}
							},
							on_attach = function(client)
								if client.name == 'ruff' then
									-- Disable hover in favor of Pyright
									client.server_capabilities.hoverProvider = false
								end
							end

						})
					end,

					pyright = function()
						lspconfig.pyright.setup({
							settings = {
								pyright = {
									-- Using Ruff's import organizer
									disableOrganizeImports = true,
								},
								python = {
									analysis = {
										-- Ignore all files for analysis to exclusively use Ruff for linting
										ignore = { '*' },
									},
								},
							},

						})
					end,

					yamlls = function()
						lspconfig.yamlls.setup({
							capabilities = {
								textDocument = {
									foldingRange = {
										dynamicRegistration = false,
										lineFoldingOnly = true,
									},
								},
							},
							settings = {
								yaml = {
									format = {
										enable = true
									},
									schemaStore = {
										enable = true
									},
									hover = true,
									validate = true,
								}
							}

						})
					end
				},
			})

			vim.diagnostic.config({
				virtual_text = false,
			})

			require('nvim_miru.plugins.lsp.jdtls')
		end,
	},
}
