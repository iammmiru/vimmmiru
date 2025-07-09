return {
  {
    "iammmiru/msg-buff.nvim",
    dir = "~/my_project/nvim_plugins/msg-buff.nvim",
    dev = function()
      if vim.fn.isdirectory(vim.fn.expand("~/my_project/nvim_plugins/msg-buff.nvim")) == 1 then
        return true
      else
        return false
      end
    end,
    opts = {
      normal_hl = "NONE",
      border_hl = "NONE",
    },
    config = function(_, opts)
      require("msg-buff").setup(opts)
    end,
  },
}
