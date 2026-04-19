return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP Support
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      "ray-x/lsp_signature.nvim",
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
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("*", {
        capabilities = cmp_capabilities,
      })

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
          "ty",
          "pyright",
          "bashls",
          "yamlls",
          "ruff",
          "jsonls",
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
        on_attach = function(client)
          -- Keep ty as the main Python LSP and use Pyright as a quiet fallback
          -- for rename when ty returns `Nothing to rename`.
          client.handlers["textDocument/publishDiagnostics"] = function() end
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.definitionProvider = false
          client.server_capabilities.declarationProvider = false
          client.server_capabilities.typeDefinitionProvider = false
          client.server_capabilities.implementationProvider = false
          client.server_capabilities.referencesProvider = false
          client.server_capabilities.documentSymbolProvider = false
          client.server_capabilities.workspaceSymbolProvider = false
          client.server_capabilities.completionProvider = nil
          client.server_capabilities.signatureHelpProvider = nil
          client.server_capabilities.codeActionProvider = false
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.inlayHintProvider = false
        end,
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
              enable = true,
            },
            schemaStore = {
              enable = true,
            },
            hover = true,
            validate = true,
            completion = true,
          },
        },
      })

      local json_capabilities = vim.lsp.protocol.make_client_capabilities()
      json_capabilities.textDocument.completion.completionItem.snippetSupport = true

      vim.lsp.config("jsonls", {
        capabilities = json_capabilities,
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      vim.lsp.enable("jdtls", false)

      require("vimmmiru.plugins.lsp.rust").setup()
      require("vimmmiru.plugins.lsp.formatter").setup()
      require("vimmmiru.plugins.lsp.lsp_signature").setup()
    end,
  },
}
