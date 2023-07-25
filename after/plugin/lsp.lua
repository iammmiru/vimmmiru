local lsp = require("lsp-zero")
local M = {}

lsp.preset("recommended")

lsp.ensure_installed({
	'lua_ls',
	'rust_analyzer',
	'jdtls',
	'pyright',
	'bashls',
})

-- lsp.skip_server_setup({ 'rust_analyzer', 'jdtls' })
-- lsp.skip_server_setup({ 'rust_analyzer' })
-- lsp.skip_server_setup({ 'jdtls' })

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


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

-- disabling cmp in comments
cmp.setup({
	enabled = function()
		local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
		if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
			return false
		end
		local context = require("cmp.config.context")
		return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
	end
})



lsp.setup_nvim_cmp({
	mapping = cmp_mappings
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

function M.lsp_attach(client, bufnr)
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

	-- if client.name == "jdtls" then
	--     vim.cmd.LspStop('jdtls')
	--     return
	-- end

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

	-- auto format rust files on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.rs",
		callback = function()
			vim.lsp.buf.format({ timeout_ms = 200 })
		end
	})
end

lsp.on_attach(M.lsp_attach)

vim.diagnostic.config({
	virtual_text = false,
})

lsp.setup()

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local rt_opts = {
	server = {
		on_attach = M.lsp_attach,
		capabilities = lsp_capabilities,
		settings = {
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				assist = {
					importPrefix = "by_self",
				},
				cargo = {
					allFeatures = true,
				},
				checkOnSave = {
					command = "clippy",
				},
				lens = {
					references = true,
					methodReferences = true,
				},
				files = {
					excludeDirs = { "/Users/mirulee/.cargo/", "/Users/mirulee/.rustup/", "base/core/src/licensing/" },
				},
			},
		},
	}
}

require('rust-tools').setup(rt_opts)

return M
