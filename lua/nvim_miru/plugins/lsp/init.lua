return {
	{
		'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			-- Rust Support
			{ 'simrat39/rust-tools.nvim' },
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local M = {}
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
					'ruff_lsp'
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
				if client.name == 'ruff_lsp' then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end

			lsp.configure('ruff_lsp', {
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

			function M.lsp_attach(_, bufnr)
				-- NOTE: Remember that lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself
				-- many times.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

				nmap("]d", vim.diagnostic.goto_next, 'Go to next error')
				nmap("[d", vim.diagnostic.goto_prev, 'Go to previous error')
				nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
				nmap('gv', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
					'[G]oto definition [V]ertical split')
				nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
				nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
				nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
				nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
				nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				-- See `:help K` for why this keymap
				nmap('K', require('rust-tools').hover_actions.hover_actions, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				-- nmap('<leader>ca', require('rust-tools').code_action_group.code_action_group, '[C]ode [A]ction')

				-- Lesser used LSP functionality
				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					if vim.lsp.buf.format then
						vim.lsp.buf.format()
					elseif vim.lsp.buf.formatting then
						vim.lsp.buf.formatting()
					end
				end, { desc = 'Format current buffer with LSP' })

				-- Show virtual text on a popup window
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = 'rounded',
							source = 'always',
							prefix = ' ',
							scope = 'cursor',
						}
						vim.diagnostic.open_float(nil, opts)
					end
				})
			end

			lsp.on_attach(M.lsp_attach)

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
			require('nvim_miru.plugins.lsp.rust')
			return M
		end,
	},
}
