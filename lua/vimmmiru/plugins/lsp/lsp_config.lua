local M = {}

function M.lsp_attach(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local lsp_keymap = function(modes, keys, func, desc)
		if #modes == 1 then
			modes = { modes }
		end
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc })
	end

	lsp_keymap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

	lsp_keymap('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	lsp_keymap('n', 'gv', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
		'[G]oto definition [V]ertical split')
	lsp_keymap('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	lsp_keymap('n', 'gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	lsp_keymap('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	lsp_keymap('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	lsp_keymap('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	lsp_keymap('n', 'K', function()
		vim.lsp.buf.hover({ border = "rounded", max_width = 120 })
	end, 'Hover Documentation')
	lsp_keymap('n', '<C-k>', function()
		vim.lsp.buf.signature_help({ border = "rounded", max_width = 120 })
	end, 'Signature Documentation')
	lsp_keymap({"n", "x"},'<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	-- Lesser used LSP functionality
	lsp_keymap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	lsp_keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	lsp_keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	lsp_keymap('n', '<leader>wl', function()
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
				border = 'rounded',
				source = 'always',
				-- prefix = ' ',
				scope = 'cursor',
			}
			vim.diagnostic.open_float(nil, opts)
		end
	})

	lsp_keymap('n', '<leader>fd', function()
		local opts = {
			-- focusable = false,
			-- close_events = { "BufLeave", "InsertEnter", "FocusLost", "WinClosed" },
			border = 'rounded',
			source = 'always',
			-- prefix = ' ',
			scope = 'cursor',
		}
		vim.diagnostic.open_float(nil, opts)
	end, "[F]ocus into [D]iagnostic float window"
	)
end

return M
