local cmd = vim.cmd            -- execute Vim commands
local exec = vim.api.nvim_exec -- execute Vimscript
local g = vim.g                -- global variables
local opt = vim.opt            -- global/buffer/windows-scoped options
local api = vim.api
local keymap = vim.keymap
local v = vim.v
local fn = vim.fn
local loop = vim.loop
local uv = vim.uv
local diagnostic = vim.diagnostic
local opts = { noremap = true, silent = true }

diagnostic.config({
  virtual_text = true,
})

cmd("set keymap=russian-jcukenwin")
cmd("set iminsert=0")
cmd("set imsearch=0")

-- set leader key to space
vim.g.mapleader = " "

opt.encoding = "utf-8"
-- Направление перевода с русского на английский
g.translate_source = "ru"
g.translate_target = "en"
g.autoformat = false

-- Компактный вид у тагбара и Отк. сортировка по имени у тагбара
g.tagbar_compact = 1
g.tagbar_sort = 0

-- opt.colorcolumn = "80"   -- Разделитель на 80 символов
opt.autochdir = false
opt.smoothscroll = true
opt.termguicolors = true --  24-bit RGB colors
opt.winblend = 0
opt.pumblend = 0
opt.ruler = true
opt.showmatch = true
opt.hlsearch = true
opt.incsearch = true
opt.mouse = "a"
opt.ttyfast = true
opt.swapfile = false
--opt.smoothscroll = true
opt.linebreak = true
opt.showbreak = ">>>>"

opt.spelllang = { "en_us", "ru" } -- Словари рус eng

opt.undolevels = 999
opt.undofile = true              -- Возможность отката назад
opt.undodir = "~/.vim/undo/"     -- keep undo files out of file dir
-- opt.directory = "~/.vim/swp/"     -- keep unsaved changes away from file dir
opt.backupdir = "~/.vim/backup/" -- backups also should not go to git

-- line number
opt.relativenumber = true
opt.number = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- tabs & indentation
opt.tabstop = 4        -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4     -- 4 spaces for indent width
opt.expandtab = true   -- expand tab to spaces
opt.autoindent = true  -- copy indent from current line when starting new one
opt.smartindent = true -- autoindent new lines

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- UFO settings
opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- keymap.set("n", "zR", require("ufo").openAllFolds)
-- keymap.set("n", "zM", require("ufo").closeAllFolds)

-- copy paste like gui
keymap.set("v", "<C-c>", '"+y<Esc>i')
keymap.set("v", "<C-x>", '"+d<Esc>i')
keymap.set("i", "<C-v>", '"+pi')
keymap.set("i", "<C-v>", '<Esc>"+pi', { noremap = true, silent = true })
keymap.set("i", "<C-z>", "<Esc>ui", { noremap = true, silent = true })
keymap.set("i", "<C-z>", "<Esc>ui", { noremap = true, silent = true })
keymap.set({ "i", "v", "x", "t" }, "<C-a>", "<C-\\><C-n>ggVG", { noremap = true, silent = true })

vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

cmd([[
filetype indent plugin on
syntax enable
]])
-- don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])
-- remove line lenght marker for selected filetypes
cmd([[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]])
-- 2 spaces for selected filetypes
cmd([[
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2
]])
-- С этой строкой отлично форматирует html файл, который содержит jinja2
cmd([[ autocmd BufNewFile,BufRead *.html set filetype=htmldjango ]])
-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------
-- Запоминает где nvim последний раз редактировал файл
cmd([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])
-- Подсвечивает на доли секунды скопированную часть текста
exec(
  [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]],
  false
)

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (uv or loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if v.shell_error ~= 0 then
    api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "iceberg" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("luarocks").setup({ rocks = { "fzy" } })

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      "packer",
      "neo-tree",
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})

require("bufferline").setup({
  options = {
    mode = "buffers",
    source_selector = {
      winbar = true,
    },
    offsets = {
      {
        filetype = "neo-tree",
        text = "󰥨 File Explorer",
        separator = true,
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})

require("telescope").load_extension("fzf")
-- require('telescope').load_extension('media_files')
-- New line in telescope previw

-- Optional, you don't have to run setup.
require("transparent").setup({
  -- table: default groups
  groups = {
    "Normal",
    "NormalNC",
    "Comment",
    "Constant",
    "Special",
    "Identifier",
    "Statement",
    "PreProc",
    "Type",
    "Underlined",
    "Todo",
    "String",
    "Function",
    "Conditional",
    "Repeat",
    "Operator",
    "Structure",
    "LineNr",
    "NonText",
    "SignColumn",
    "CursorLine",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
    "EndOfBuffer",
  },
  -- table: additional groups that should be cleared
  extra_groups = {},
  -- table: groups you don't want to clear
  exclude_groups = {
    "NeoTreeCursorLine",
  },
  -- function: code to be executed after highlight groups are cleared
  -- Also the user event "TransparentClear" will be triggered
  on_clear = function() end,
})

require("nvim-web-devicons").setup({
  -- your personal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh",
    },
  },
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true,
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,
  -- set the light or dark variant manually, instead of relying on `background`
  -- (default to nil)
  variant = "light|dark",
  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore",
    },
  },
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log",
    },
  },
  -- same as `override` but specifically for operating system
  -- takes effect when `strict` is true
  override_by_operating_system = {
    ["apple"] = {
      icon = "",
      color = "#A2AAAD",
      cterm_color = "248",
      name = "Apple",
    },
  },
})

-- Conform
require("conform").setup({
  formatters_by_ft = {
    -- lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
    --javascript = { "prettier", "eslint" },
    --typescript = { "prettier", "eslint" },
    --javascriptreact = { "prettier", "eslint" },
    --typescriptreact = { "prettier", "eslint" },
    --svelte = { "prettier" },
    css = { "prettier" },
    --html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
  },
})

require("ufo").setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
})

-- Autopairs for coq
local remap = api.nvim_set_keymap
local npairs = require("nvim-autopairs")

npairs.setup({ map_bs = false, map_cr = false })

g.coq_settings = { keymap = { recommended = false } }

-- these mappings are coq recommended mappings unrelated to nvim-autopairs
remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

-- skip it, if you use another global object
_G.MUtils = {}

MUtils.CR = function()
  if fn.pumvisible() ~= 0 then
    if fn.complete_info({ "selected" }).selected ~= -1 then
      return npairs.esc("<c-y>")
    else
      return npairs.esc("<c-e>") .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

MUtils.BS = function()
  if fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
    return npairs.esc("<c-e>") .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
--

require("lazy").setup({ { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" } })

require("nvim-highlight-colors").setup({})

api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

require("transparent").clear_prefix("NeoTree")
-- require("transparent").clear_prefix("lualine")
--require('transparent').clear_prefix('NvimTree')
require("transparent").clear_prefix("bufferline")
require("transparent").clear_prefix("ToggleTerm")
require("transparent").clear_prefix("coq")
require("transparent").clear_prefix("nvim-lspconfig")
require("transparent").clear_prefix("NormalFloat")
require("transparent").clear_prefix("FloatBorder")
require("transparent").clear_prefix("colortils")
--require("transparent").clear_prefix("Telescope")

require("bufferline").setup({
  options = {},
})
local builtin = require("telescope.builtin")

-- Neo tree colors
api.nvim_set_hl(0, "NeoTreeCursorLine", { fg = "#b28500", bold = true })
api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#268bd3", bold = true })
--api.nvim_set_hl(0, "NeoTreeRootName", { fg = "##29a298", bold = true })
api.nvim_set_hl(0, "PMenu", { bg = "none", blend = 0 })
api.nvim_set_hl(0, "FloatBorder", { bg = "none", blend = 0 })
api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none" })
api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none" })
api.nvim_set_hl(0, "StatusLine", { bg = "none", blend = 0 })
-- vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#A6E22E", bg = nil, bold = true })

api.nvim_create_augroup("neotree", {})
api.nvim_create_autocmd("UiEnter", {
  desc = "Open Neotree automatically",
  group = "neotree",
  callback = function()
    cmd("Neotree toggle")
  end,
})

-- UFO
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
keymap.set("n", "zR", require("ufo").openAllFolds)
keymap.set("n", "zM", require("ufo").closeAllFolds)

-- Grug-far
keymap.set("n", "<leader>w", "<cmd>GrugFar<cr>", { silent = true })

-- Telescope
keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
--
-- copy paste like gui
keymap.set("v", "<C-c>", '"+y<Esc>i')
keymap.set("v", "<C-x>", '"+d<Esc>i')
keymap.set("i", "<C-v>", '"+pi')
keymap.set("i", "<C-v>", '<Esc>"+pi', { noremap = true, silent = true })
keymap.set("i", "<C-z>", "<Esc>ui", { noremap = true, silent = true })
keymap.set("i", "<C-z>", "<Esc>ui", { noremap = true, silent = true })
keymap.set({ "i", "v", "x", "t" }, "<C-a>", "<C-\\><C-n>ggVG", { noremap = true, silent = true })

-- Select all
keymap.set("i", "C-a", "gg<S-v>G")

-- Tabs
keymap.set("n", "te", "tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)

--Split windows
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
