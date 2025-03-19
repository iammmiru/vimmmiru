local lsp_attach = require("nvim_miru.plugins.lsp.lsp_config")

local SYSTEM = "linux"
if vim.fn.has "mac" == 1 then
    SYSTEM = "mac"
end

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()


local jdtls_path = vim.fn.stdpath('data') .. "/mason/packages/jdtls"
local path_to_lsp_server = jdtls_path .. "/config_" .. SYSTEM
local path_to_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_path = jdtls_path .. "/lombok.jar"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name

local lspconfig = require('lspconfig')
lspconfig.jdtls.setup({
    -- cmd = {'jdtls'},
    cmd = {
        '/usr/bin/java',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        -- '-Dosgi.checkConfiguration=true',
        -- '-Dosgi.sharedConfiguration.area='..path_to_lsp_server,
        -- '-Dosgi.sharedConfiguration.area.readOnly=true',
        -- '-Dosgi.configuration.cascaded=true',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. lombok_path,
        '-Xms1G',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', path_to_jar,
        '-configuration', path_to_lsp_server,
        -- '-data', '/var/folders/w6/s7cw1mf96kd32dzydrmj8qlm0000gn/T/jdtls-8df74f65f436a682b1313b894eee93abfcb7a976',
        '-data', workspace_dir,
    },
    root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle") or vim.fn.getcwd(),
    on_attach = lsp_attach.lsp_attach,
    capabilities = lsp_capabilities,
})
