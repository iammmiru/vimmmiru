local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('rust-tools').setup(
	{
		server = {
			on_attach = function()
				-- auto format rust files on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = "*.rs",
					callback = function()
						vim.lsp.buf.format({ timeout_ms = 200 })
					end
				})

				-- workaround for ServerCancelled error spam
				for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
					local default_diagnostic_handler = vim.lsp.handlers[method]
					vim.lsp.handlers[method] = function(err, result, context, config)
						if err ~= nil and err.code == -32802 then
							return
						end
						return default_diagnostic_handler(err, result, context, config)
					end
				end
			end,
			capabilities = lsp_capabilities,
			settings = {
				-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
				["rust-analyzer"] = {
					check = {
						command = "clippy"
					},
					files = {
						excludeDirs = { "/Users/mirulee/.cargo/", "/Users/mirulee/.rustup/" },
					},
				},
			},
		}

	}
)
