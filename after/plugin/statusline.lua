-- local ts_utils = require('nvim-treesitter.ts_utils')
-- local ts_query = require('vim.treesitter.query')
--
-- local function get_current_function_name(_,bufnr)
--     local current_node = ts_utils.get_node_at_cursor()
--     if not current_node then return "" end
--
--     local expr = current_node
--
--     while expr do
--         if expr:type() == 'function_declaration' or expr:type() == 'function_item' then
--             break
--         end
--         expr = expr:parent()
--     end
--
--     if not expr then return "" end
--     print(bufnr)
--     -- print(vim.api.nvim_buf_line_count(bufnr))
--
--     return (ts_query.get_node_text(expr:child(2),bufnr,{concat = true}))
--     -- return expr:type()
--     -- return ts_utils.get_node_text(expr:type())[1]
-- end
-- print(require('nvim-treesitter').statusline)

require('lualine').setup {
    options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
    },
    -- sections = {
    --     lualine_c = {'filename', require('nvim-treesitter').statusline}
    -- }
}
