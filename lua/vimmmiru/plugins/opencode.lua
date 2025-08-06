return {
  "sudo-tee/opencode.nvim",
  enabled = false,
  config = function()
    require("opencode").setup({
      prefered_picker = "telescope",
      ui = {
        position = "left", -- 'right' (default) or 'left'. Position of the UI split
        input_position = "bottom", -- 'bottom' (default) or 'top'. Position of the input window
        window_width = 0.3, -- Width as percentage of editor width
        input_height = 0.15, -- Input height as percentage of window height
        display_model = true, -- Display model name on top winbar
        display_context_size = true, -- Display context size in the footer
        display_cost = true, -- Display cost in the footer
        window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder", -- Highlight group for the opencode window
        output = {
          tools = {
            show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
          },
        },
        input = {
          text = {
            wrap = true, -- Wraps text inside input window
          },
        },
      },
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
  },
}
