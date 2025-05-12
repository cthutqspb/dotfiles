return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    -- media_files = {
    --   -- filetypes whitelist
    --   -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
    --   filetypes = { "png", "webp", "jpg", "jpeg" },
    --   -- find command (defaults to `fd`)
    --   find_cmd = "rg"
    -- },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    --'nvim-lua/popup.nvim',
    --'nvim-telescope/telescope-media-files.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  }
}
