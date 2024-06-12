return {
	{
		'tpope/vim-fugitive',
		commit = "4f59455d2388e113bd510e85b310d15b9228ca0d",
		config = function()
			vim.keymap.set("n", "<leader>gits", require('telescope.builtin').git_status, { desc = 'show git status' })
			vim.keymap.set("n", "<leader>gitc", require('telescope.builtin').git_commits, { desc = 'show git commits' })
			vim.keymap.set("n", "<leader>gitb", require('telescope.builtin').git_branches, { desc = 'show git branches' })
			vim.keymap.set("n", "<leader>gitss", require('telescope.builtin').git_stash, { desc = 'show git stash' })
		end,
	}
}
