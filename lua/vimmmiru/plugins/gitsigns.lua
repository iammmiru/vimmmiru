return {
  "lewis6991/gitsigns.nvim",
  opts = {
    preview_config = {
      -- Options passed to nvim_open_win
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
      border = "rounded",
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 200,
    },

    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "Next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "Previous hunk" })

      -- Actions
      map("n", "ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
      map("n", "ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })

      map("v", "ghs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage hunk (visual)" })

      map("v", "ghr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset hunk (visual)" })

      map("n", "ghS", gitsigns.stage_buffer, { desc = "Stage buffer" })
      map("n", "ghR", gitsigns.reset_buffer, { desc = "Reset buffer" })
      map("n", "ghp", gitsigns.preview_hunk, { desc = "Preview hunk" })
      map("n", "ghi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

      map("n", "ghb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Show git blame under cursor" })

      map("n", "ghd", gitsigns.diffthis, { desc = "Diff this hunk" })

      map("n", "ghD", function()
        gitsigns.diffthis("~")
      end, { desc = "Diff this hunk against HEAD" })

      map("n", "ghQ", function()
        gitsigns.setqflist("all")
      end, { desc = "Set quickfix list with all hunks" })
      map("n", "ghq", gitsigns.setqflist, { desc = "Set quickfix list with current hunk" })

      -- Toggles
      map("n", "gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
      map("n", "gtw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
    end,
  },
}
