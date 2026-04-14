return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = {
      "markdown",
    },
    sign = { enabled = false },
    heading = {
      backgrounds = {
        "NONE",
        "NONE",
        "NONE",
        "NONE",
        "NONE",
      },
    },
    completions = { lsp = { enabled = true } },
  },
}
