return {
	{
		'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
			-- Rust Support
			require("nvim_miru.plugins.lsp.rust"),
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config")
			local lsp = require("lsp-zero")

			lsp.preset("recommended")

			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'lua_ls',
					'rust_analyzer',
					'jdtls',
					'pyright',
					'bashls',
					'yamlls',
					'ruff',
				},
			})

			-- Fix Undefined global 'vim'
			lsp.configure('lua_ls', {
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' }
						}
					}
				}
			})

			local on_attach = function(client, _)
				if client.name == 'ruff' then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end

			lsp.configure('ruff', {
				init_options = {
					settings = {
						args = {},
					}
				},
				on_attach = on_attach
			})

			lsp.configure('pyright', {
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

			lsp.set_preferences({
				suggest_lsp_servers = false,
				sign_icons = {
					error = 'E',
					warn = 'W',
					hint = 'H',
					info = 'I'
				}
			})

			lsp.on_attach(lsp_attach.lsp_attach)

			vim.diagnostic.config({
				virtual_text = false,
			})

			lsp.setup()

			lsp.configure('yamlls', {
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

			require('nvim_miru.plugins.lsp.jdtls')
			return lsp_attach
		end,
	},
}
