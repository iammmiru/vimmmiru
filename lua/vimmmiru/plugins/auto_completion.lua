return {
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_confirm = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }

      local completion_word = function(entry)
        local item = entry.completion_item
        local word = entry.word or item.word or item.textEditText or item.insertText or item.label
        return vim.split(word, "\n", { plain = true })[1]
      end

      local replace_current_identifier = function(entry)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]
        local line = vim.api.nvim_get_current_line()
        local start_col = (line:sub(1, col):match("()[%w_$]*$") or (col + 1)) - 1
        local word = completion_word(entry)

        cmp.abort()
        vim.api.nvim_buf_set_text(0, row, start_col, row, col, { word })
        vim.api.nvim_win_set_cursor(0, { row + 1, start_col + #word })

        return row
      end

      local apply_lsp_edits_off_current_line = function(entry, current_row)
        local edits = vim.tbl_filter(function(edit)
          return edit.range.start.line ~= current_row
        end, entry.completion_item.additionalTextEdits or {})

        if #edits > 0 then
          vim.lsp.util.apply_text_edits(edits, vim.api.nvim_get_current_buf(), entry.source:get_position_encoding_kind())
        end
      end

      local confirm_completion = function()
        local entry = cmp.get_selected_entry() or cmp.get_entries()[1]
        local source_name = entry and entry.source and entry.source.name
        local lsp_client_name = source_name == "nvim_lsp" and entry.source.source.client.name
        local use_lsp_workaround = {
          svelte = true,
          ts_ls = true,
          tsserver = true,
          vtsls = true,
        }

        if source_name == "buffer" then
          replace_current_identifier(entry)
          return
        end

        if source_name == "nvim_lsp" then
          if not use_lsp_workaround[lsp_client_name] then
            cmp.confirm(cmp_confirm)
            return
          end

          entry:resolve(function()
            local row = replace_current_identifier(entry)
            apply_lsp_edits_off_current_line(entry, row)
          end)
          return
        end

        cmp.confirm(cmp_confirm)
      end

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-CR>"] = cmp.mapping(confirm_completion, { "i", "s" }),
        }),
        -- disabling cmp in comments
        enabled = function()
          local in_prompt = vim.bo.buftype == "prompt"
          if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
            return false
          end
          local context = require("cmp.config.context")
          return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
        end,

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "render-markdown" },
        }, {
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
          { name = "crates" },
        }, {
          { name = "copilot" },
        }),

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })

      local ls = require("luasnip")
      ls.config.set_config({
        history = false,
        updateevents = "TextChanged, TextChangedI",
      })

      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
    end,
  },
}
