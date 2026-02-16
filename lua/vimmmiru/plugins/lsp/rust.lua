local Rust = {}

vim.g.rustaceanvim = {
	tools = {
		float_win_config = {
			border = "rounded",
			max_width = 120,
		},
	},
	server = {
		cmd = { "/Users/mirulee/.cargo/bin/rust-analyzer" },
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		standalone = false,
		-- cmd_env = {
		-- 	RA_LOG = "proc-macro=debug",
		-- },
		default_settings = {
			["rust-analyzer"] = {
				checkOnSave = true,
				files = {
					watcher = "client",
					-- excludeDirs = { "/Users/mirulee/.cargo/", "/Users/mirulee/.rustup/" },
				},
				procMacro = {
					enabled = true,
				},
			},
		},
	},
}

Rust.lsp_attach = function(_, bufnr)
	local lsp_attach = require("vimmmiru.plugins.lsp.lsp_config")

	lsp_attach.lsp_attach(_, bufnr)

	vim.keymap.set("n", "<leader>ca", function()
		vim.cmd.RustLsp("codeAction")
	end, { silent = true, buffer = bufnr })
	vim.keymap.set("n", "<leader>ce", function()
		vim.cmd.RustLsp("explainError", "cycle")
	end, { silent = true, buffer = bufnr })
	vim.keymap.set(
		"n",
		"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
		function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end,
		{ silent = true, buffer = bufnr }
	)
	vim.keymap.set("n", "<leader>rt", function()
		vim.cmd.RustLsp({ "run" })
	end, { silent = true, buffer = bufnr })
	vim.keymap.set("n", "<leader>ra", function()
		vim.cmd.RustLsp({ "runnables" })
	end, { silent = true, buffer = bufnr })

	for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
		local default_diagnostic_handler = vim.lsp.handlers[method]
		vim.lsp.handlers[method] = function(err, result, context, config)
			if err ~= nil and err.code == -32802 then
				return
			end
			return default_diagnostic_handler(err, result, context, config)
		end
	end
end

Rust.setup = function()
	require("crates").setup({
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
		completion = {
			cmp = {
				enabled = true,
			},
		},
	})
end

return Rust
