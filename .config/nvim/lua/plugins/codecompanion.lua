return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ui = {
      picker = {
        default = "select",  -- или "telescope", "fzf", "snacks"
      },
    }, 
    strategies = {
      chat = {
        adapter = "ollama",        
        tools = {
          ["editor"] = {
            callback = "editor",  -- разрешаем редактирование
            opts = {
              auto_submit = true,  -- автоматически применять изменения
            },
          },
          ["cmd_runner"] = {
            callback = "cmd_runner",  -- разрешаем команды
          },
        },
      },
      inline = {
        adapter = "ollama",  -- и для инлайн-режима тоже
      },
    },
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          env = {
            url = "http://localhost:11434",  -- адрес Ollama
          },
          schema = {
            model = {
              default = "qwen3-coder:30b",  -- ТВОЯ МОДЕЛЬ
            },
              system = [[
                Ты — ассистент по программированию.
                ОТВЕЧАЙ ТОЛЬКО НА РУССКОМ ЯЗЫКЕ, даже если спрашивают на английском.
                Специализация: JavaScript, TypeScript, Lua (Neovim), Bash, Linux.
                Все объяснения, код и комментарии должны быть на русском.
                Код пиши на языке программирования, но комментарии внутри кода — на русском.
            ]],
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini_cli", {
          env = {
            -- Путь к gemini-cli (обычно в PATH)
            cmd = "gemini",
            -- Если используешь API ключ вместо CLI
            -- api_key = os.getenv("GEMINI_API_KEY"),
          },
          schema = {
            model = {
              default = "gemini-2.5-flash",  -- или pro, если хочешь
            },
          },
        })
      end,
    },
  },
  keys = {        -- добавляем сюда
    { "<leader>q", ":CodeCompanionChat<CR>", desc = "Chat with selection", mode = "v" },
    { "<leader>qq", ":CodeCompanionChat<CR>", desc = "Chat with buffer", mode = "n" },
  },
  -- opts = {
  --   adapters = {
  --     deepseek = function()
  --       return require("codecompanion.adapters").extend("deepseek", {
  --         env = {
  --           api_key = "sk-ae77f9f1f5124393b0833154e92d9958",
  --         },
  --         schema = {
  --           model = {
  --             default = "deepseek-chat", -- или deepseek-reasoner
  --           },
  --         },
  --       })
  --     end,
  --   },
  --   strategies = {
  --     chat = { adapter = "deepseek" },
  --     inline = { adapter = "deepseek" },
  --   },
  -- }
}
