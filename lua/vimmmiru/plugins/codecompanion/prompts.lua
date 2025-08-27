Prompts = {}

Prompts.commit_prompt = function()
  local staged_diff = vim.fn.system("git diff --no-ext-diff --staged")
  local prompt = string.format(
    [[
You are an expert at following the Conventional Commit specification.
Generates concise, explanatory Git commit messages based on the provided diffs.
You don't have to write out all miscellaneous changes, e.g., the contents of lock files update or dependency updates, but focus on the main changes made in the staged files.
Wrap the commit message in a code block.
```diff
%s
```
]],
    staged_diff
  )
  return prompt
end

Prompts.sys_prompt_appendix = [[
When you are suggesting or editing the code, always just apply your suggestions or changes to the editor or buffer, instead of asking whether to apply.
Always assume that the user wants to review your changes or suggestions in the editer.
Always prefer using tools over outright coming up with answers by yourself. For instance, if the user asks you to perform simple arithmetic or conversions (time, unit, etc), use the calculator tool or command line tools instead of calculating it yourself.
]]

local plugin_path = vim.api.nvim_get_runtime_file("lua/vimmmiru/plugins/codecompanion/beast_mode_3_1.md", false)[1]
local lines = vim.fn.readfile(plugin_path)
Prompts.beast_mode_prompt = table.concat(lines, "\n")

return Prompts
