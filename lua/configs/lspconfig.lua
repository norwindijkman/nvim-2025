require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "phpactor",
  "marksman",
  "svelte",
  "jdtls",
  "omnisharp",
  "intelephense",
}

vim.lsp.enable(servers)
