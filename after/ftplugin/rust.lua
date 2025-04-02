local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
	"n",
	"<leader>ca",
	function()
		vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
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
