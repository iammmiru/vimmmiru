return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  enabled = false,
  dependencies = {
    "folke/snacks.nvim",
    {
      "iammmiru/aider-addons.nvim",
      dir = "~/my_project/nvim_plugins/aider-addons.nvim",
      dev = function()
        return vim.fn.isdirectory("~/my_project/nvim_plugins/aider-addons.nvim") == 1
      end,
    },
  },
  keys = {
    { "<leader>aa",  "<cmd>Aider toggle<cr>",             desc = "Toggle Aider" },
    { "<leader>ase", "<cmd>Aider send<cr>",               desc = "Send to Aider",          mode = { "n", "v" } },
    { "<leader>ac",  "<cmd>Aider command<cr>",            desc = "Aider Commands" },
    { "<leader>ab",  "<cmd>Aider buffer<cr>",             desc = "Send Buffer" },
    { "<leader>a+",  "<cmd>Aider add<cr>",                desc = "Add File" },
    { "<leader>a-",  "<cmd>Aider drop<cr>",               desc = "Drop File" },
    { "<leader>ar",  "<cmd>Aider add readonly<cr>",       desc = "Add Read-Only" },
    { "<leader>aR",  "<cmd>Aider reset<cr>",              desc = "Reset Session" },
    { "<leader>ad",  "<cmd>Aider buffer diagnostics<cr>", desc = "Send buffer diagnostics" },
  },
  opts = {
    -- Command that executes Aider
    aider_cmd = "aider-copilot",
    -- Command line arguments passed to aider
    args = {
      "--no-auto-commits",
      "--pretty",
      "--stream",
      "--watch-files",
    },
    -- Automatically reload buffers changed by Aider (requires vim.o.autoread = true)
    auto_reload = true,
    picker_cfg = {
      preset = "vscode",
    },
    -- Other snacks.terminal.Opts options
    config = {
      os = { editPreset = "nvim-remote" },
      gui = { nerdFontsVersion = "3" },
    },
    win = {
      wo = {
        winhighlight = "Normal:Normal,NormalNC:NormalNC,WinBar:WinBar,WinBarNC:WinBarNC",
      },
      keys = {
        q = false,
        term_normal = {
          "<esc>",
          function()
            vim.cmd("stopinsert")
          end,
          mode = "t",
          expr = true,
        },
      },
      position = "left",
      width = 0.3,
    },
    start_insert = false,
    auto_insert = false,
  },
  config = function(_, opts)
    require("nvim_aider").setup(opts)
    require("aider-addons.commit_message").setup({
      send_to_aider_api = require("nvim_aider").api.send_to_terminal
    }
    )
    local aider_diff = require("aider-addons.diff")
    aider_diff.setup({
      confirm_revert = false,
    })

    vim.keymap.set("n", "<leader>asd", function() aider_diff.diff_with_previous_undo() end,
      { desc = "[A]ider [S]how [D]iff" })
  end
}
