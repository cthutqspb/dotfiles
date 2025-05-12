return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  config = function()
    require("colortils").setup({
      border = "single",
      blend = 0,
      bg = "none",
    })
  end,
}
