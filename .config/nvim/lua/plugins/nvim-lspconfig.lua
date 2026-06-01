return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Сначала инициализируем Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'ts_ls',
          "cssls",
          "eslint",
          "html",
          "jsonls",
          "tailwindcss",
          "bashls",
          'rust_analyzer',
          'clangd',
        },
        automatic_installation = true,
      })

      -- 2. Отключаем всплывающие сообщения от серверов
      vim.lsp.handlers["window/showMessage"] = function() end
      vim.lsp.handlers["window/showMessageRequest"] = function() end
      vim.lsp.handlers["window/logMessage"] = function() end
      
      -- Уровень логов
      vim.lsp.log.set_level(vim.log.levels.WARN)

      -- 3. Общий on_attach
      local on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.workDoneProgress = false
      end

      local lspconfig = require("lspconfig")

      -- 4. Настройка lua_ls для Defold
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            workspace = {
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.api.nvim_get_runtime_file("", true),
                vim.fn.getcwd() .. "/.internal",
              },
              checkThirdParty = false,
            },
            diagnostics = {
              globals = {
                "go", "gui", "msg", "url", "sys", "resource", "sound", "sprite",
                "timer", "vmath", "window", "collectionfactory", "factory",
                "particlefx", "render", "tilemap", "json", "html5", "http",
                "socket", "on_message", "on_input", "update", "init", "final", "hash"
              },
            },
            hint = { enable = true },
          },
        },
      })

      -- 5. Список остальных серверов для быстрой настройки
      local servers = {
        "pyright", "ts_ls", "cssls", "eslint", "html",
        "jsonls", "tailwindcss", "bashls", "rust_analyzer", "clangd"
      }

      for _, lsp in ipairs(servers) do
        -- Проверка на случай, если имя сервера изменится (как tsserver -> ts_ls)
        if lspconfig[lsp] then
          lspconfig[lsp].setup({
            on_attach = on_attach,
          })
        end
      end
    end,
  }, 
-- return {
  --  {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "williamboman/mason-lspconfig.nvim",
  --   },
  --   config = function()
  --     -- ОТКЛЮЧАЕМ НАДОЕДЛИВЫЕ СООБЩЕНИЯ ГЛОБАЛЬНО
  --     -- Это ключевое решение вашей проблемы с логами
  --     vim.lsp.handlers["window/showMessage"] = function() end
  --     vim.lsp.handlers["window/showMessageRequest"] = function() end
  --     vim.lsp.handlers["window/logMessage"] = function() end
  --     
  --     -- Устанавливаем уровень логов на WARN (не показываем debug/info)
  --     vim.lsp.log.set_level(vim.log.levels.WARN)
  --
  --     -- Базовый on_attach для всех серверов
  --     local on_attach = function(client, bufnr)
  --       -- Отключаем уведомления о форматировании
  --       client.server_capabilities.documentFormattingProvider = false
  --       client.server_capabilities.documentRangeFormattingProvider = false
  --       
  --       -- Отключаем прогресс-уведомления
  --       client.server_capabilities.workDoneProgress = false
  --     end
  --
  --     -- Настройка конкретных серверов
  --     local lspconfig = require("lspconfig")
  --     
  --     -- lua_ls с поддержкой Defold
  --     lspconfig.lua_ls.setup({
  --       on_attach = on_attach,
  --       settings = {
  --         Lua = {
  --           runtime = { version = "Lua 5.1" },
  --           workspace = {
  --             -- Это заставит LSP видеть код библиотек (Druid и др.)
  --             library = {
  --                 vim.fn.expand("$VIMRUNTIME/lua"),
  --                 vim.api.nvim_get_runtime_file("", true), -- подтягивает плагины nvim
  --                 vim.fn.getcwd() .. "/.internal",         -- пробуем корень .internal
  --             },
  --             checkThirdParty = false,
  --           },
  --           diagnostics = {
  --             globals = {
  --               "go", "gui", "msg", "url", "sys", "resource", "sound", "sprite",
  --               "timer", "vmath", "window", "collectionfactory", "factory",
  --               "particlefx", "render", "tilemap", "json", "html5", "http",
  --               "socket", "on_message", "on_input", "update", "init", "final",
  --               "hash" -- кстати, добавьте hash, его не было в вашем списке
  --             },
  --           },
  --           hint = { enable = true },
  --         },
  --       },
  --     })
  --
  --     -- Другие серверы с базовым on_attach
  --     lspconfig.pyright.setup({ on_attach = on_attach })
  --     lspconfig.ts_ls.setup({ on_attach = on_attach })
  --     lspconfig.cssls.setup({ on_attach = on_attach })
  --     lspconfig.eslint.setup({ on_attach = on_attach })
  --     lspconfig.html.setup({ on_attach = on_attach })
  --     lspconfig.jsonls.setup({ on_attach = on_attach })
  --     lspconfig.tailwindcss.setup({ on_attach = on_attach })
  --     lspconfig.bashls.setup({ on_attach = on_attach })
  --     lspconfig.rust_analyzer.setup({ on_attach = on_attach })
  --     lspconfig.clangd.setup({ on_attach = on_attach })
  --     
  --     -- hlsl нестандартный, возможно нужен отдельный обработчик
  --     -- lspconfig.hlsl.setup({ on_attach = on_attach })
  --   end,
  -- }, 
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "williamboman/mason-lspconfig.nvim",
  --   },
  --   opts = {
  --     ensure_installed = {
  --       'lua_ls',
  --       'pyright',
  --       'ts_ls',
  --       "cssls",
  --       "eslint",
  --       "html",
  --       "jsonls",
  --       "tailwindcss",
  --       "bashls",
  --       'rust_analyzer',
  --       'clangd',
  --       -- 'hlsl' -- возможно не поддерживается mason-ом
  --     },
  --     -- Автоматически настраивать серверы после установки
  --     automatic_installation = true,
  --   },
  --   config = function(_, opts)
  --     require("mason").setup()
  --     require("mason-lspconfig").setup(opts)
  --   end,
  -- },



  -- { 
  --   "neovim/nvim-lspconfig",   
  -- },
  -- {
  --   "mason-org/mason.nvim",
  --   opts = {}
  -- },
  -- {
  --   "mason-org/mason-lspconfig.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "mason-org/mason.nvim"
  --   },
  --   opts = {
  --     ensure_installed = {
  --       'lua_ls', -- Lua (great for editing Neovim config)
  --       'pyright', -- Python
  --       'ts_ls', -- TypeScript / JavaScript
  --       "cssls",
  --       "eslint",
  --       "html",
  --       "jsonls",
  --       "tailwindcss",
  --       "bashls",
  --       'rust_analyzer', -- Rust
  --       'clangd', -- C / C++
  --       'hlsl'
  --     }
  --   }
  -- }
	-- "neovim/nvim-lspconfig",
	-- event = { "BufReadPre", "BufNewFile" },
	-- opts = {
	-- 	autoformat = false,
	-- },
	-- dependencies = {
	-- 	"hrsh7th/cmp-nvim-lsp",
	-- 	{ "folke/neodev.nvim", opts = {} },
	-- },
	--
	-- config = function()
	-- 	vim.lsp.config("*", {})
	-- 	vim.lsp.enable({
	-- 		"cssls",
	-- 		"eslint",
	-- 		"html",
	-- 		"jsonls",
	-- 		"ts_ls",
	-- 		"pyright",
	-- 		"tailwindcss",
	-- 		"lua_ls",
	-- 		"bashls",
	-- 	})
	-- end,

	-- config = function()
	-- 	require("mason-lspconfig").setup()
	-- ehnd,

	-- config = function()
	-- 	local nvim_lsp = require("lspconfig")
	-- 	local mason_lspconfig = require("mason-lspconfig")

	-- local on_attach = function(client, bufnr)
	-- 	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	-- 	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	--
	-- 	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	-- 	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
	-- 	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	--
	-- 	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
	-- 	-- format on save
	-- 	if client.server_capabilities.documentFormattingProvider then
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			group = vim.api.nvim_create_augroup("Format", { clear = true }),
	-- 			buffer = bufnr,
	-- 			callback = function()
	-- 				vim.lsp.buf.format()
	-- 			end,
	-- 		})
	-- 	end
	-- end

	-- 	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	--
	-- 	mason_lspconfig.setup_handlers({
	-- 		function(server)
	-- 			nvim_lsp[server].setup({
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["ts_ls"] = function()
	-- 			nvim_lsp["ts_ls"].setup({
	-- 				autostart = true,
	-- 				filetypes = {
	-- 					"javascript",
	-- 					"javascriptreact",
	-- 					"javascript.jsx",
	-- 					"typescript",
	-- 					"typescriptreact",
	-- 					"typescript.tsx",
	-- 				},
	-- 				root_dir = function()
	-- 					return vim.loop.cwd()
	-- 				end,
	-- 				-- root_dir = require("lspconfig").util.root_pattern({ "package.json", "tsconfig.json" }),
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["cssls"] = function()
	-- 			nvim_lsp["cssls"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["tailwindcss"] = function()
	-- 			nvim_lsp["tailwindcss"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["html"] = function()
	-- 			nvim_lsp["html"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["jsonls"] = function()
	-- 			nvim_lsp["jsonls"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["eslint"] = function()
	-- 			nvim_lsp["eslint"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["pyright"] = function()
	-- 			nvim_lsp["pyright"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 		["lua_ls"] = function()
	-- 			nvim_lsp["lua_ls"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 				settings = {
	-- 					Lua = {
	-- 						diagnostics = {
	-- 							globals = { "vim" },
	-- 						},
	-- 					},
	-- 				},
	-- 			})
	-- 		end,
	-- 		["bashls"] = function()
	-- 			nvim_lsp["bashls"].setup({
	-- 				on_attach = on_attach,
	-- 				capabilities = capabilities,
	-- 			})
	-- 		end,
	-- 	})
	-- end,
}
