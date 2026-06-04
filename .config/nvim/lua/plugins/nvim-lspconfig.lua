return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Инициализируем Mason
      require("mason").setup()
      
      -- 2. Отключаем всплывающие сообщения от серверов
      vim.lsp.handlers["window/showMessage"] = function() end
      vim.lsp.handlers["window/showMessageRequest"] = function() end
      vim.lsp.handlers["window/logMessage"] = function() end
      vim.lsp.log.set_level(vim.log.levels.WARN)

      -- 3. Общие возможности (capabilities) для серверов
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      -- 4. НАСТРОЙКА MASON БЕЗ ЖЕСТКИХ СТОЛКНОВЕНИЙ С DEFOLD.NVIM
      require("mason-lspconfig").setup({
        ensure_installed = {
          'lua_ls', 'pyright', 'ts_ls', "cssls", "eslint", 
          "html", "jsonls", "tailwindcss", "bashls", 'rust_analyzer', 'clangd',
        },
        automatic_installation = true,
        handlers = {
          -- Дефолтный хэндлер для всех обычных серверов
          function(server_name)
            -- Строго игнорируем emmylua_ls, чтобы он не запускался параллельно
            if server_name == "emmylua_ls" then return end
            -- Пропускаем lua_ls, так как под него написана отдельная логика ниже
            if server_name == "lua_ls" then return end
            
            -- Каноничный нативный запуск серверов в Neovim
            vim.lsp.config(server_name, { capabilities = capabilities })
            vim.lsp.enable(server_name)
          end,

          -- Полностью блокируем автоматический старт emmylua_ls через Mason
          ["emmylua_ls"] = function()
            -- Пустая функция отменяет инициализацию этого сервера
          end,

          -- 🧱 ПРАВИЛЬНЫЙ ХЭНДЛЕР ДЛЯ LUA (СЛИЯНИЕ НАСТРОЕК С DEFOLD.NVIM):
          ["lua_ls"] = function()
            -- Извлекаем настройки, которые УЖЕ подготовил нативный конфиг defold.nvim
            local defold_config = vim.lsp.config["lua_ls"] or {}
            local default_settings = defold_config.settings or {}

            -- Глубокое объединение дефолтных настроек Defold и твоих кастомных
            local final_settings = vim.tbl_deep_extend("force", default_settings, {
              Lua = {
                runtime = { 
                  version = "Lua 5.1",
                  path = { '?.lua', '?/init.lua' }
                },
                workspace = {
                  -- Подтягиваем все рантаймы, которые дает Neovim и библиотеки проекта
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                diagnostics = {
                  disable = { "protected-access", "undefined-doc-name" },
                  -- Дублируем ключи globals/globalsc для совместимости разных версий парсера lua_ls
                  globals = {
                    "go", "gui", "msg", "url", "sys", "resource", "sound", "sprite",
                    "timer", "vmath", "window", "collectionfactory", "factory",
                    "particlefx", "render", "tilemap", "json", "html5", "http",
                    "socket", "on_message", "on_input", "update", "init", "final", "hash"
                  },
                  globalsc = {
                    "go", "gui", "msg", "url", "sys", "resource", "sound", "sprite",
                    "timer", "vmath", "window", "collectionfactory", "factory",
                    "particlefx", "render", "tilemap", "json", "html5", "http",
                    "socket", "on_message", "on_input", "update", "init", "final", "hash"
                  },
                },
                telemetry = { enable = false },
                hint = { enable = true },
              },
            })

            -- Записываем конфигурацию в нативный движок и принудительно включаем сервер
            vim.lsp.config("lua_ls", {
              capabilities = capabilities,
              settings = final_settings,
            })
            vim.lsp.enable("lua_ls")
          end,
        }
      })
    end,
  },
}


-- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "williamboman/mason-lspconfig.nvim",
  --   },
  --   config = function()
  --     -- 1. Сначала инициализируем Mason
  --     require("mason").setup()
  --     require("mason-lspconfig").setup({
  --       ensure_installed = {
  --         'lua_ls',
  --         'pyright',
  --         'ts_ls',
  --         "cssls",
  --         "eslint",
  --         "html",
  --         "jsonls",
  --         "tailwindcss",
  --         "bashls",
  --         'rust_analyzer',
  --         'clangd',
  --       },
  --       automatic_installation = true,
  --     })
  --
  --     -- 2. Отключаем всплывающие сообщения от серверов
  --     vim.lsp.handlers["window/showMessage"] = function() end
  --     vim.lsp.handlers["window/showMessageRequest"] = function() end
  --     vim.lsp.handlers["window/logMessage"] = function() end
  --     
  --     -- Уровень логов
  --     vim.lsp.log.set_level(vim.log.levels.WARN)
  --
  --     -- 3. Общий on_attach
  --     local on_attach = function(client, bufnr)
  --       client.server_capabilities.documentFormattingProvider = false
  --       client.server_capabilities.documentRangeFormattingProvider = false
  --       client.server_capabilities.workDoneProgress = false
  --     end
  --
  --     local lspconfig = require("lspconfig")
  --
  --     -- 4. Настройка lua_ls для Defold
  --     lspconfig.lua_ls.setup({
  --       on_attach = on_attach,
  --       settings = {
  --         Lua = {
  --           runtime = { version = "Lua 5.1" },
  --           workspace = {
  --             library = {
  --               vim.fn.expand("$VIMRUNTIME/lua"),
  --               vim.api.nvim_get_runtime_file("", true),
  --               -- 🎯 ТОЧНЫЙ АДРЕС ТИПОВ: Указываем подпапку, где лежат Си-чертежи hash и vector3
  --               vim.fn.getcwd() .. "/.internal/lua-annotations",
  --             },
  --             checkThirdParty = false,
  --           },
  --           diagnostics = {
  --             -- 🎯 ВЫЖИГАЕМ ЛОЖНЫЕ ВАРНИНГИ: protected-access и придирки к док-аннотациям в ---@param
  --             disable = { "protected-access", "undefined-doc-name" },
  --             globals = {
  --               "go", "gui", "msg", "url", "sys", "resource", "sound", "sprite",
  --               "timer", "vmath", "window", "collectionfactory", "factory",
  --               "particlefx", "render", "tilemap", "json", "html5", "http",
  --               "socket", "on_message", "on_input", "update", "init", "final", "hash"
  --             },
  --           },
  --           hint = { enable = true },
  --         },
  --       },
  --     })
  --
  --     -- 5. Список остальных серверов для быстрой настройки
  --     local servers = {
  --       "pyright", "ts_ls", "cssls", "eslint", "html",
  --       "jsonls", "tailwindcss", "bashls", "rust_analyzer", "clangd"
  --     }
  --
  --     for _, lsp in ipairs(servers) do
  --       -- Проверка на случай, если имя сервера изменится (как tsserver -> ts_ls)
  --       if lspconfig[lsp] then
  --         lspconfig[lsp].setup({
  --           on_attach = on_attach,
  --         })
  --       end
  --     end
  --   end,
  -- }, 

