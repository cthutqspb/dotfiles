return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", 
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
      autotag = {
        enable = true,
      },

      ensure_installed = {
        "astro", "cmake", "cpp", "css", "gitignore", "go", "graphql", "http",
        "java", "php", "rust", "scss", "sql", "svelte", "javascript", "typescript",
        "tsx", "json", "bash", "html", "regex", "yaml", "csv", "dockerfile",
        "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
        "python", "latex", 
      },

      -- Блоки query_linter и playground удалены, так как ветка main их больше не поддерживает
    },
    config = function(_, opts)
      -- ФИКС: убрали букву "s" из названия модуля nvim-treesitter.config
      require("nvim-treesitter.config").setup(opts)

      -- Настройка MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  }
}
