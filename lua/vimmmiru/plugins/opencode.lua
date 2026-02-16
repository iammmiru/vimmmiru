return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  enabled = true,
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = "snacks", -- Default when `snacks.terminal` is enabled.
        snacks = {
          win = {
            wo = {
              winhighlight = "Normal:Normal,NormalNC:NormalNC,WinBar:WinBar,WinBarNC:WinBarNC",
            },
            position = "left",
            width = 0.35,
            enter = false,
          },
        },
      },
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.auto_reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>op", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<leader>ot", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
    vim.keymap.set("n", "<A-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "opencode half page up" })
    vim.keymap.set("n", "<A-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "opencode half page down" })
  end,
}
