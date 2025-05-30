local options = {
  default_format_opts = {
    timeout_ms = 100000,
    lsp_fallback = true,
    async = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    twig = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

require("conform").setup(options)
