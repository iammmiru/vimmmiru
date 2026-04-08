return {
  "zbirenbaum/copilot.lua",
  dependencies = {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    local exclude_dirs = { vim.fn.expand("$HOME/aivis/engine-v2"), vim.fn.expand("$HOME/my_project/neetcode") }
    require("copilot").setup({
      should_attach = function(_, _)
        local root_dir = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p"))
        for _, dir in ipairs(exclude_dirs) do
          if dir == root_dir then
            return false
          end
        end
        return true
      end,
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
}
