return {
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'hrsh7th/cmp-nvim-lsp-signature-help' },
			{ 'hrsh7th/cmp-vsnip' },
			{ 'hrsh7th/vim-vsnip' },
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
					{ name = "vsnip" },
					{ name = "luasnip" },
				}
			})
		end,
	}
}
