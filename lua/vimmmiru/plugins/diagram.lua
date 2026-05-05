return {
  {
    "3rd/diagram.nvim",
    dependencies = {
      {
        "3rd/image.nvim",
        build = false,
        opts = {
          backend = "kitty",
          processor = "magick_cli",
          integrations = {
            markdown = { enabled = false },
            asciidoc = { enabled = false },
            typst = { enabled = false },
            neorg = { enabled = false },
            syslang = { enabled = false },
            html = { enabled = false },
            css = { enabled = false },
            org = { enabled = false },
          },
        },
      },
    },
    opts = function()
      return {
        integrations = {
          require("diagram.integrations.markdown"),
        },
        renderer_options = {
          mermaid = {
            backend = "transparent",
            theme = "forest",
            scale = 3,
          },
        },
      }
    end,
  },
}
