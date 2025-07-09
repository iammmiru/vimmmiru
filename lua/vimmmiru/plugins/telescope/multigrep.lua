local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

local function command_generator(prompt)
  if not prompt or prompt == "" then
    return nil
  end

  local promts = vim.split(prompt, "  ")
  local search = promts[1]
  local glob = promts[2]

  local args = { "--color=never", "--no-heading", "--line-number", "--column", "--smart-case", "--with-filename" }
  if glob then
    table.insert(args, "-g")
    table.insert(args, glob)
  end
  table.insert(args, "-e")
  table.insert(args, search)
  return { "rg", unpack(args) }
end

local create_finder = function(opts)
  return finders.new_async_job({
    command_generator = command_generator,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.search_cwd,
  })
end

M.live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "MultiGrep",
      finder = create_finder(opts),
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

return M
