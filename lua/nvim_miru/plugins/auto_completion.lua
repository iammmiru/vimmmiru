return {
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
		},
		event = 'InsertEnter',
		config = function()
			local cmp = require('cmp')
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-e>'] = cmp.mapping.abort(),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				-- disabling cmp in comments
				enabled = function()
					local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
					if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
						return false
					end
					local context = require("cmp.config.context")
					return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
				end,

				sources = {
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "crates" },
				},

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})

			local ls = require('luasnip')
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
	}
}
