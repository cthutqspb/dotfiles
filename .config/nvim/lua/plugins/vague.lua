return {
  "vague2k/vague.nvim",
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require("vague").setup({
      -- optional configuration here
      --  vim.cmd([[colorscheme vague]]),
      --  vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
    })
  end,
}
