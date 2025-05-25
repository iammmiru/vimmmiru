return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		keys = function()
			vim.keymap.set('n', '<leader>/', require('telescope.builtin').oldfiles,
				{ desc = 'Telescope: [/] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
				{ desc = 'Telescope: [ ] Find existing buffers' })

			vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,
				{ desc = 'Telescope: [S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags,
				{ desc = 'Telescope: [S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
				{ desc = 'Telescope: [S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', require('vimmmiru.plugins.telescope.multigrep').live_multigrep,
				{ desc = 'Telescope: [S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
				{ desc = 'Telescope: [S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches,
				{ desc = 'Telescope: [G]it [B]ranches' })
			vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits,
				{ desc = 'Telescope: [G]it [C]ommits' })
			vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status,
				{ desc = 'Telescope: [G]it [S]tatus' })
			vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps,
				{ desc = 'Telescope: [S]how [K]eymaps' })
		end,
		opts = {
			extensions = {
				fzf = {}
			},
			defaults = {
				layout_config = {
					width = 0.9,
					preview_width = 0.4,
				},
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
					n = {
						["d"] = "delete_buffer",
					}
				},
				initial_mode = 'normal'
			},
		},
		config = function (_, opts)
			require('telescope').setup(opts)
			require('telescope').load_extension('fzf')
		end
	}
}
