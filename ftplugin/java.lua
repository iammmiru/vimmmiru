-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- Only for Linux and Mac
local SYSTEM = "linux"
if vim.fn.has "mac" == 1 then
    SYSTEM = "mac"
end

local JDTLS_LOCATION = "/opt/homebrew/Cellar/jdtls/1.18.0/libexec"
local HOME = os.getenv "HOME"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = HOME .. '/.cache/jdtls/workspace/' .. project_name

-- local config = {
--     cmd = { 'jdtls',
--         '-configuration',
--         JDTLS_LOCATION .. "/config_" .. SYSTEM,
--         -- See `data directory configuration` section in the README
--         '-data',
--         workspace_dir,
--     },
--     root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
-- }


local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        -- JDTLS_LOCATION .. '/bin/jdtls',
        'java',
        -- 'java', -- or '/path/to/java17_or_newer/bin/java'
        -- -- depends on if `java` is in your $PATH env variable and if it points to the right version.
        --
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        -- "-javaagent:" .. JDTLS_LOCATION .. "/lombok.jar",
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar',
        vim.fn.glob(JDTLS_LOCATION .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

        '-configuration',
        JDTLS_LOCATION .. "/config_" .. SYSTEM,

        -- See `data directory configuration` section in the README
        '-data',
        workspace_dir,
    },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
-- require('jdtls').start_or_attach(config)

require("jdtls.setup").add_commands()
