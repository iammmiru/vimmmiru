Formatter = {}
local conform = require("conform")
local opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		rust = { "rustfmt" },
		java = { "google-java-format" },
		yaml = { lsp_format = "prefer" },
		json = { lsp_format = "prefer" },
	},
}

local formatters = { "google-java-format", "stylua" }

local mason_registgry = require("mason-registry")

for _, formatter in ipairs(formatters) do
	if not mason_registgry.is_installed(formatter) then
		vim.notify("Install " .. formatter)
		if mason_registgry.has_package(formatter) then
			mason_registgry.get_package(formatter):install()
		else
			vim.notify("Package " .. formatter .. " not found in Mason registry")
		end
	end
end

Formatter.setup = function()
	conform.setup(opts)
	vim.keymap.set("n", "<leader>lf", require("conform").format, { desc = "Format the file" })
end

return Formatter
