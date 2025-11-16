local M = {}

-- Load modules
M.core = require("custom.ai_manager.core")
M.term = require("custom.ai_manager.term")
M.tree = require("custom.ai_manager.tree")
M.picker = require("custom.ai_manager.picker")

-- Setup keymaps (side-effects)
pcall(require, "custom.ai_manager.keymaps")

-- Backwards-compatible exports
M.open_ai_project = M.picker.open_ai_project
M.open_project = M.picker.open_project

return M
