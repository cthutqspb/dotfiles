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
          -- Дефолтный хэндлер для всех обычных серверов (ФИКС: используем lspconfig вместо vim.lsp.config)
          function(server_name)
            if server_name == "emmylua_ls" then return end
            if server_name == "lua_ls" then return end
            
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Полностью блокируем автоматический старт emmylua_ls через Mason
          ["emmylua_ls"] = function()
            -- Пустая функция отменяет инициализацию этого сервера
          end,

          -- 🧱 ПРАВИЛЬНЫЙ ХЭНДЛЕР ДЛЯ LUA (СЛИЯНИЕ НАСТРОЕК С DEFOLD.NVIM):
          ["lua_ls"] = function()
            -- Безопасно извлекаем настройки, если defold.nvim что-то подготовил
            local defold_config = require("lspconfig").lua_ls or {}
            local default_settings = defold_config.settings or {}

            -- Глубокое объединение дефолтных настроек Defold и ваших кастомных
            local final_settings = vim.tbl_deep_extend("force", default_settings, {
              Lua = {
                runtime = { 
                  version = "Lua 5.1",
                  path = { '?.lua', '?/init.lua' }
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                diagnostics = {
                  -- ФИКС: добавили отключение undefined-field, чтобы не ругалось на .zones и .exists
                  disable = { "protected-access", "undefined-doc-name", "undefined-field" },
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

            -- ФИКС: Применяем конфигурацию через классический стабильный API lspconfig
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = final_settings,
            })
          end,
        }
      })
    end,
  },
}

