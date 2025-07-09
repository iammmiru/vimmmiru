return {
  "Davidyz/VectorCode",
  version = "*", -- optional, depending on whether you're on nightly or release
  build = "uv tool upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    async_backend = "lsp",
    on_setup = {
      lsp = true,
    },
  },
}
