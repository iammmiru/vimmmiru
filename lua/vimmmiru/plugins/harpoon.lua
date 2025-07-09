local function git_branch()
  local pipe = io.popen("git branch --show-current 2>/dev/null")
  if pipe then
    local branch = pipe:read("*l")
    if branch then
      local c = branch:match("^%s*(.-)%s*$")
      pipe:close()
      return c
    else
      return "default list"
    end
  end
  return "default list"
end

return {
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<C-e>a", function()
        harpoon:list(git_branch()):add()
      end)
      vim.keymap.set("n", "<C-e>e", function()
        harpoon.ui:toggle_quick_menu(harpoon:list(git_branch()))
      end)

      vim.keymap.set("n", "<C-e>1", function()
        harpoon:list(git_branch()):select(1)
      end)
      vim.keymap.set("n", "<C-e>2", function()
        harpoon:list(git_branch()):select(2)
      end)
      vim.keymap.set("n", "<C-e>3", function()
        harpoon:list(git_branch()):select(3)
      end)
      vim.keymap.set("n", "<C-e>4", function()
        harpoon:list(git_branch()):select(4)
      end)

      vim.api.nvim_create_autocmd({ "filetype" }, {
        pattern = "harpoon",
        callback = function()
          vim.api.nvim_set_option_value(
            "winhighlight",
            "NormalFloat:HarpoonWindow,FloatBorder:HarpoonBorder",
            { win = 0 }
          )
        end,
      })
      vim.api.nvim_set_hl(0, "HarpoonWindow", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "HarpoonBorder", { bg = "NONE" })
    end,
  },
}
