local lsp_attach = require('lsp').lsp_attach
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local rt_opts = {
    server = {
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        settings = {
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                assist = {
                    importPrefix = "by_self",
                },
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
                lens = {
                    references = true,
                    methodReferences = true,
                },
            },
        },
    }
}

require('rust-tools').setup(rt_opts)
