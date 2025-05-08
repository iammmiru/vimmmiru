return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	enabled = false,
	version = false, -- Never set this value to "*"! Never!
	opts = {
		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()
			return hub:get_active_servers_prompt()
		end,
		-- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
		-- This function defines custom tools available to the Avante plugin.
		-- It integrates with MCPHub to provide additional functionalities by returning a list of tool definitions.
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(), -- Provides the mcp_tool for Avante
			}
		end,
		-- add any opts here
		-- for example
		provider = "gemini-2.5-pro",
		cursor_applying_provider = 'gemini-2.0-flash',
		mode = "agentic",
		auto_suggestion_providor = "gemini-2.5-pro",
		-- gemini = {
		-- 	-- endpoint = "https://api.openai.com/v1",
		-- 	model = "gemini-2.5-flash-preview-04-17", -- your desired model (or use gpt-4o, etc.)
		-- 	-- timeout = 30000,        -- Timeout in milliseconds, increase this for reasoning models
		-- 	-- temperature = 0,
		-- 	-- max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
		-- 	--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
		-- },
		-- copilot = {
		-- endpoint = "https://api.githubcopilot.com",
		-- model = "gpt-4o-2024-11-20",
		-- proxy = nil,    -- [protocol://]host[:port] Use this proxy
		-- allow_insecure = false, -- Allow insecure server connections
		-- timeout = 30000, -- Timeout in milliseconds
		-- temperature = 0,
		-- max_tokens = 20480,
		-- },
		vendors = {
			["claude-3.7"] = {
				__inherited_from = "copilot",
				display_name = "copilot/claude-3.7",
				model = "claude-3.7-sonnet",
			},
			["gemini-2.5-pro"] = {
				__inherited_from = "copilot",
				display_name = "copilot/gemini-2.5-pro",
				model = "gemini-2.5-pro",
				disabled_tools = true,
			},
			["gemini-2.0-flash"] = {
				__inherited_from = "copilot",
				display_name = "copilot/gemini-2.0-flash",
				model = "gemini-2.0-flash",
				disabled_tools = true,
			},
		},
		behaviour = {
			enable_cursor_planning_mode = true,
			auto_focus_sidebar = true,
			auto_suggestions = true, -- Experimental stage
			auto_suggestions_respect_ignore = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = true,
			jump_result_buffer_on_finish = false,
			support_paste_from_clipboard = false,
			minimize_diff = true,
			enable_token_counting = true,
			use_cwd_as_project_root = false,
			auto_focus_on_diff_view = false,
		},
		windows = {
			edit = {
				border = "rounded",
				start_insert = false, -- Start insert mode when opening the edit window
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = false, -- Start insert mode when opening the ask window
				border = "rounded",
				---@type "ours" | "theirs"
				focus_on_apply = "ours", -- which diff to focus after applying
			},
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick",   -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp",        -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua",        -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua",
		{
			"ravitemer/mcphub.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
			},
			-- uncomment the following line to load hub lazily
			--cmd = "MCPHub",  -- lazy load
			build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
			-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
			-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
			config = function()
				require("mcphub").setup(
					{
						extensions = {
							avante = {
								make_slash_commands = true, -- make /slash commands from MCP server prompts
							}
						}
					}
				)
			end,
		},
		-- for providers='copilot'
		-- {
		-- 	-- support for image pasting
		-- 	"HakonHarnes/img-clip.nvim",
		-- 	event = "VeryLazy",
		-- 	opts = {
		-- 		-- recommended settings
		-- 		default = {
		-- 			embed_image_as_base64 = false,
		-- 			prompt_for_file_name = false,
		-- 			drag_and_drop = {
		-- 				insert_mode = true,
		-- 			},
		-- 			-- required for Windows users
		-- 			use_absolute_path = true,
		-- 		},
		-- 	},
		-- },
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
