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
    html = { "prettier", "jsbeautify" }, -- run js-beautify after prettier
    twig = { "prettier", "jsbeautify" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier", "jsbeautify" }, -- added js-beautify
    terraform = { "terraform_fmt" },
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
    jsbeautify = {
      command = "npx",
      args = {
        "js-beautify",
        "--type",
        "html",
        "--wrap-attributes",
        "force-expand-multiline", -- each attribute on its own line
        "--end-with-newline",
      },
      stdin = true,
      cwd = require("conform.util").root_file({ "package.json" }),
    },
  },
})
