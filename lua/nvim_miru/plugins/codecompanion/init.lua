return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	dependencies = {
		"j-hui/fidget.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"zbirenbaum/copilot.lua",
		require("nvim_miru.plugins.codecompanion.mcphub_config"),
		require("nvim_miru.plugins.codecompanion.vectorcode"),
		"ravitemer/codecompanion-history.nvim",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "my_gpt_4_1",
				keymaps = {
					send = {
						modes = { n = "<CR>", i = "<S-CR>" },
					}
				}
			},
			inline = {
				adapter = "my_gpt_4_1",
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
		log_level = "DEBUG",
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ",      -- Prompt used for interactive LLM calls
				provider = "default",    -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
				opts = {
					show_default_actions = true, -- Show the default actions in the action palette?
					show_default_prompt_library = true, -- Show the default prompt library in the action palette?
				},
			},

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
					position = "left", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
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
		adapters = {
			my_gemini_2_5_pro = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gemini-2.5-pro",
						},
					},
				})
			end,
			my_claude_3_7 = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-3.7-sonnet",
						},
					},
				})
			end,
			my_gpt_4_1 = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gpt-4.1",
						},
					},
				})
			end,
			my_gpt_4o_mini = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "4o-mini",
						},
					},
				})
			end,
		},
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					show_result_in_chat = true, -- Show mcp tool results in chat
					make_vars = true, -- Convert resources to #variables
					make_slash_commands = true, -- Add prompts as /slash commands
				},
			},
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "gh",
					-- Automatically generate titles for new chats
					auto_generate_title = true,
					---On exiting and entering neovim, loads the last chat on opening chat
					continue_last_chat = true,
					---When chat is cleared with `gx` delete the chat from history
					delete_on_clearing_chat = false,
					-- Picker interface ("telescope", "snacks" or "default")
					picker = "telescope",
					---Enable detailed logging for history extension
					enable_logging = false,
					---Directory path to save the chats
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					-- Save all chats by default
					auto_save = true,
					-- Keymap to save the current chat manually
					save_chat_keymap = "sc",
				}
			},
			vectorcode = {
				opts = {
					add_tool = true,
				}
			}
		},
	},
	init = function()
		local fidget_spinner_ok, fidget_spinner = pcall(require, "nvim_miru.plugins.codecompanion.fidget-spinner")
		if fidget_spinner_ok then
			fidget_spinner:init()
		else
			vim.notify("Failed to load nvim_miru.plugins.codecompanion.fidget-spinner", vim.log.levels.WARN)
		end

		local chat_spinner_ok, chat_spinner = pcall(require, "nvim_miru.plugins.codecompanion.chat-spinner")
		if chat_spinner_ok then
			chat_spinner:init()
		else
			vim.notify("Failed to load nvim_miru.plugins.codecompanion.spinner", vim.log.levels.WARN)
		end

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
