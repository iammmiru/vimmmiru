return {
  {
    "iammmiru/diagnostic-jumper.nvim",
    dir = "~/my_project/nvim_plugins/diagnostic-jumper.nvim",
    event = { "LspAttach" },
    dev = function()
      if vim.fn.isdirectory(vim.fn.expand("~/my_project/nvim_plugins/diagnostic-jumper.nvim")) == 1 then
        return true
      else
        return false
      end
    end,
    config = function()
      local diagpang = require("diagnostic-jumper")

      vim.keymap.set("n", "]p", function()
        diagpang.jump({ count = 1 })
      end, { desc = "DiagnosticJumper: Next Diagnostic" })
      vim.keymap.set("n", "[p", function()
        diagpang.jump({ count = -1 })
      end, { desc = "DiagnosticJumper: Prev Diagnostic" })
    end,
  },
}
