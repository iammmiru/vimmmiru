return {
	{
		"tpope/vim-fugitive",
    cmd = "G",
		config = function()
			vim.keymap.set("n", "<leader>gits", require("telescope.builtin").git_status, { desc = "show git status" })
			vim.keymap.set("n", "<leader>gitc", require("telescope.builtin").git_commits, { desc = "show git commits" })
			vim.keymap.set(
				"n",
				"<leader>gitb",
				require("telescope.builtin").git_branches,
				{ desc = "show git branches" }
			)
			vim.keymap.set("n", "<leader>gitss", require("telescope.builtin").git_stash, { desc = "show git stash" })
		end,
	},
}
