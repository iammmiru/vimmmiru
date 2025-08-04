local SYSTEM = "linux"
if vim.fn.has("mac") == 1 then
  SYSTEM = "mac"
end

local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local path_to_lsp_server = jdtls_path .. "/config_" .. SYSTEM
local path_to_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_path = jdtls_path .. "/lombok.jar"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

local config = {
  cmd = {
    "/opt/homebrew/bin/java",
    "-javaagent:" .. lombok_path,
    "-jar",
    path_to_jar,
    "-configuration",
    path_to_lsp_server,
    "-data",
    workspace_dir,
  },

  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "build.gradle" }),
}
require("jdtls").start_or_attach(config)
