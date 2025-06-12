return {
  "olimorris/codecompanion.nvim",
  enabled = true,
  dependencies = {
    "j-hui/fidget.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "zbirenbaum/copilot.lua",
    require("vimmmiru.plugins.codecompanion.mcphub_config"),
    require("vimmmiru.plugins.codecompanion.vectorcode"),
    "ravitemer/codecompanion-history.nvim",
  },
  opts = {
    log_level = "DEBUG",
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
        provider = "default",                 -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true,        -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },

      diff = {
        enabled = true,
        close_chat_at = 30,   -- Close an open chat buffer if the total columns of your display are less than...
        layout = "vertical",  -- vertical|horizontal split for default provider
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
          position = "left",   -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
          border = "single",
          height = 1.0,
          width = 0.3,
          relative = "editor",
          full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
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
      opts = {
        show_defaults = false,
        show_model_choices = true,
      },
      copilot_gemini_2_5_pro = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gemini_2_5_pro",
          schema = {
            model = {
              default = "gemini-2.5-pro",
            },
          },
        })
      end,
      copilot_gemini_2_0_flash = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gemini_2_0_flash",
          schema = {
            model = {
              default = "gemini-2.0-flash-001",
            },
          },
        })
      end,
      copilot_claude_3_7 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_3_7",
          schema = {
            model = {
              default = "claude-3.7-sonnet",
            },
          },
        })
      end,
      copilot_claude_3_5 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_3_5",
          schema = {
            model = {
              default = "claude-3.5-sonnet",
            },
          },
        })
      end,
      copilot_claude_3_7_thought = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_3_7_thought",
          schema = {
            model = {
              default = "claude-3.7-sonnet-thought",
            },
          },
        })
      end,
      copilot_claude_4 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_4",
          schema = {
            model = {
              default = "claude-sonnet-4",
            },
          },
        })
      end,
      copilot_gpt_4_1 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt_4_1",
          schema = {
            model = {
              default = "gpt-4.1",
            },
          },
        })
      end,
      copilot_gpt_o4_mini = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt_o4_mini",
          schema = {
            model = {
              default = "o4-mini",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot_gpt_4_1",
        keymaps = {
          send = {
            modes = { n = "<CR>", i = "<S-CR>" },
          }
        },
        tools = {
          ["next_edit_suggestion"] = {
            opts = {
              --- the default is to open in a new tab, and reuse existing tabs
              --- where possible
              ---@type string|fun(path: string):integer?
              jump_action = 'tabnew',
            },
          },
          opts = {
            auto_submit_errors = true,  -- Send any errors to the LLM automatically?
            auto_submit_success = true, -- Send any successful output to the LLM automatically?
          },
        },
      },
      inline = {
        adapter = "copilot_gpt_4_1",
        keymaps = {
          accept_change = {
            modes = { n = "q" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gj" },
            description = "Reject the suggested change",
          },
        },
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true,           -- Convert resources to #variables
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
          picker = "snacks",
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
    local fidget_spinner_ok, fidget_spinner = pcall(require, "vimmmiru.plugins.codecompanion.fidget-spinner")
    if fidget_spinner_ok then
      fidget_spinner:init()
    else
      vim.notify("Failed to load vimmmiru.plugins.codecompanion.fidget-spinner", vim.log.levels.WARN)
    end

    local chat_spinner_ok, chat_spinner = pcall(require, "vimmmiru.plugins.codecompanion.chat-spinner")
    if chat_spinner_ok then
      chat_spinner:init()
    else
      vim.notify("Failed to load vimmmiru.plugins.codecompanion.spinner", vim.log.levels.WARN)
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
  -- Simple print function for tool usage testing
  utils = {
    print_tool_usage = function(tool_name, params)
      print("Tool Usage: " .. tool_name)
      if params then
        print("Parameters: " .. vim.inspect(params))
      end
    end
  },
  config = function(_, opts)
    local default_prompt = require("codecompanion.config").opts.system_prompt({})
    local prompt_appendix = [[
    When you are suggesting or editing the code, just apply your suggestions or changes to the editor or buffer,
    instead of asking whether to apply.
    Always assume that the user wants to review your changes or suggestions in the editer.
    Always prefer using tools over outright coming up with answers by yourself. For instance, if the user asks you to perform
    simple arithmetic or conversions (time, unit, etc), use the calculator tool or command line tools instead of calculating it yourself.
    ]]
    local system_prompt = default_prompt .. "\n" .. prompt_appendix
    local config = {
      opts = {
        system_prompt = function(_)
          return system_prompt
        end
      }
    }
    opts = vim.tbl_deep_extend("force", opts, config)
    require("codecompanion").setup(opts)
  end,
}

