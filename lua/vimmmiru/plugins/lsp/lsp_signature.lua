LspSignature = {}

local lsp_signature = require("lsp_signature")
local opts = {
  hint_enable = false,
  ignore_error = function(err, ctx, _)
    if ctx and ctx.client_id then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and client.name == "rust-analyzer" then
        if err.code == -32801 then
          return true
        end
      end
    end
  end,
}

LspSignature.setup = function()
  lsp_signature.setup(opts)
end

return LspSignature
