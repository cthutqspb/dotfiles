return {
	"nvim-telescope/telescope.nvim",
	-- 🧱 ФИКС: Убрали 'tag = "0.1.8"', чтобы Lazy подтянул свежую ветку master, 
	-- в которой исправлен краш из-за обновления nvim-treesitter.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				preview = {
					filetype_hook = function(filepath, bufnr, opts)
						-- Извлекаем чистое расширение файла (например, script или gui_script)
						local ext = vim.fn.fnamemodify(filepath, ":e")

						-- Массив твоих расширений, которые должны быть Lua
						local target_extensions = {
							script = true,
							gui_script = true,
							render_script = true,
							editor_script = true,
						}

						-- Если это твое расширение, принудительно перебиваем системный тип на lua
						if target_extensions[ext] then
							opts.ft = "lua"
						end

						return true
					end,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- Загружаем расширение после инициализации setup
		require("telescope").load_extension("fzf")
	end,
}


