local conform = require("conform")

conform.setup({
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
    svelte = { "prettier" },
  },

  formatters = {
    prettier = {
      command = "npx",
      args = {
        "prettier",
        "--stdin-filepath",
        "$FILENAME",
      },
      cwd = require("conform.util").root_file({ "package.json", ".prettierrc", ".prettierrc.json" }),
      stdin = true,
    },
  },
})
