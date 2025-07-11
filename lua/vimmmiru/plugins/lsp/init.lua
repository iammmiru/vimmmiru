return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP Support
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      require("vimmmiru.plugins.lsp.lsp_signature"),
      { "mfussenegger/nvim-jdtls" },
      "stevearc/conform.nvim",
      "nvim-telescope/telescope.nvim",
      { "mrcjkb/rustaceanvim", version = "^6" },
      {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config

      lsp_defaults.capabilities =
        vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

      local lsp_attach = require("vimmmiru.plugins.lsp.lsp_config").lsp_attach
      local rust = require("vimmmiru.plugins.lsp.rust")

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id).name
          if client == "rust-analyzer" then
            rust.lsp_attach(_, event.buf)
          elseif client ~= "copilot" and client ~= "vectorcode_server" then
            lsp_attach(_, event.buf)
          end
        end,
      })

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "jdtls",
          "pyright",
          "bashls",
          "yamlls",
          "ruff",
        },
        automatic_enable = true,
      })

      vim.diagnostic.config({
        virtual_text = false,
      })

      vim.lsp.config("lua_ls", require("vimmmiru.plugins.lsp.lua_ls"))

      vim.lsp.config("ruff", {
        init_options = {
          settings = {
            args = {},
          },
        },
        on_attach = function(client)
          if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
      })

      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      })
      vim.lsp.config("yamlls", {
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        settings = {
          yaml = {
            format = {
              enable = false,
            },
            schemaStore = {
              enable = true,
            },
            hover = true,
            validate = true,
          },
        },
      })

      vim.lsp.enable("jdtls", false)

      require("vimmmiru.plugins.lsp.rust").setup()
      require("vimmmiru.plugins.lsp.formatter").setup()
    end,
  },
}
