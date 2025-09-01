-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvchad",
}

M.ui = {
	theme = "gruvchad",

  statusline = {
    theme = "minimal",
    order = { "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp" },
    enabled = false,
  },

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
    Visual = {
      bg = "#453b4a",
      fg = "#FFFFFF",
    },
    Normal = {
      bg = "#000000",
    },
    Search = { bg = "#ffcc00", fg = "#000000" },      -- Color for other matches
    CurSearch = { bg = "#ff0000", fg = "#FFFFFF" },   -- Color for current match
    IncSearch = { bg = "#ff0000", fg = "#FFFFFF" },   -- Color for current match
    SearchCurrent = { bg = "#ff0000", fg = "#FFFFFF" }, -- Alternative for current match
	},
}

vim.api.nvim_set_hl(0, "CurSearch", { bg = "#ff0000", fg = "#FFFFFF" })

-- Function to toggle the status bar
function ToggleStatusbar()
    M.ui.statusline.enabled = not M.ui.statusline.enabled
    if M.ui.statusline.enabled then
        vim.o.laststatus = 2  -- Show the status bar
        vim.o.cmdheight = 1   -- Show the command line
    else
        vim.o.laststatus = 0  -- Hide the status bar
        vim.o.cmdheight = 0   -- Hide the command line
    end
end

-- Keybinding to toggle the status bar
vim.api.nvim_set_keymap('n', '<leader>ts', ':lua ToggleStatusbar()<CR>', { noremap = true, silent = true })

return M
