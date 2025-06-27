local custom_prompts = require("vimmmiru.plugins.codecompanion.prompts")

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
  opts = function()
    local config = {
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
      },
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-4.1"
          },
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
          adapter = {
            name = "copilot",
            model = "gpt-4.1"
          },
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
      prompt_library = {
        ["Generate a Commit Message"] = {
          strategy = "chat",
          description = "Generate a commit message",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = custom_prompts.commit_prompt,
              opts = {
                contains_code = true,
              },
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
    }
    local default_sys_prompt = require("codecompanion.config").opts.system_prompt({})
    local system_prompt = default_sys_prompt .. "\n" .. custom_prompts.sys_prompt_appendix
    local additional_config = {
      opts = {
        system_prompt = function(_)
          return system_prompt
        end
      }
    }
    config = vim.tbl_deep_extend("force", config, additional_config)
    return config
  end,
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
}
