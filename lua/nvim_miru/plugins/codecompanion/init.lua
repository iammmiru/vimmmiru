return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	dependencies = {
		"j-hui/fidget.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"zbirenbaum/copilot.lua",
	},
	opts = {
		display = {
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
			chat = {
				-- Change the default icons
				icons = {
					pinned_buffer = " ",
					watched_buffer = "👀 ",
				},

				-- Alter the sizing of the debug window
				debug_window = {
					---@return number|fun(): number
					width = vim.o.columns - 5,
					---@return number|fun(): number
					height = vim.o.lines - 2,
				},

				-- Options to customize the UI of the chat buffer
				window = {
					layout = "vertical", -- float|vertical|horizontal|buffer
					position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
					border = "single",
					height = 0.8,
					width = 0.3,
					relative = "editor",
					full_height = false, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
					opts = {
						breakindent = true,
						cursorcolumn = false,
						cursorline = false,
						foldcolumn = "0",
						linebreak = true,
						list = false,
						numberwidth = 1,
						signcolumn = "no",
						spell = false,
						wrap = true,
						winfixwidth = true,
						winfixheight = true,
					},
				},
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				keymaps = {
					send = {
						modes = { n = "<C-CR>", i = "<C-CR>" },
					}
				}
			},
			inline = {
				adapter = "copilot",
				keymaps = {
					accept_change = {
						modes = { n = "ga" },
						description = "Accept the suggested change",
					},
					reject_change = {
						modes = { n = "gr" },
						description = "Reject the suggested change",
					},
				},
			},
		},
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gemini-2.5-pro",
						},
					},
				})
			end,
		}
	},
	init = function()
		require("nvim_miru.plugins.codecompanion.fidget-spinner"):init()
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionChatSubmitted",
			callback = function()
				vim.cmd("stopinsert")
			end,
			desc = "Exit insert mode after submitting to CodeCompanionChat",
		})
		-- require('mini.diff').setup()
	end,
	keys = {
		{
			"<leader>aa",
			"<cmd>CodeCompanionChat Toggle<CR>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "Open/Toggle CodeCompanion Chat",
		},
		{
			"<leader>ac",
			"<cmd>CodeCompanionActions<CR>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "Open CodeCompanionAcitions",
		},
		{
			"<leader>ae",
			"<cmd>CodeCompanionChat Add<CR>",
			desc = "Add code to a chat buffer",
			mode = { "v" },
		},

	},
}
