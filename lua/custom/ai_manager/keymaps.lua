local core = require("custom.ai_manager.core")
local term = require("custom.ai_manager.term")
local tree = require("custom.ai_manager.tree")
local picker = require("custom.ai_manager.picker")

local slots = term.get_slots()

-- Leader menu to open AI project manager (Telescope)
vim.keymap.set("n", "<leader>ai", picker.open_ai_project, { desc = "Open AI project manager" })

-- Terminal slot 1 (main)
vim.keymap.set({ "n", "t" }, "<A-\\>", function()
  if slots[1].path then
    term.toggle_term(slots[1].id)
  else
    local default_path = "~/softw/penguin/ai/main"
    core.ensure_agents_md(default_path)
    term.toggle_term(slots[1].id, default_path)
    slots[1].path = default_path
  end
end, { desc = "Toggle ai main slot" })

-- Terminal slot 2 (current project)
vim.keymap.set({ "n", "t" }, "<A-]>", function()
  if slots[2].path then
    term.toggle_term(slots[2].id)
  else
    local project_path = vim.fn.getcwd()
    term.toggle_term(slots[2].id, project_path)
    slots[2].path = project_path
  end
end, { desc = "Toggle ai 2th slot" })

-- Terminal slot 3 (picker)
vim.keymap.set({ "n", "t" }, "<A-[>", function()
  if slots[3].path then
    term.toggle_term(slots[3].id)
  else
    picker.open_ai_project(3, "term")
  end
end, { desc = "Toggle ai 3th slot" })

-- Tree slot 1 (main)
vim.keymap.set({ "n", "t" }, "<A-|>", function()
  if slots[1].path then
    tree.open_tree(slots[1].path)
  else
    local default_path = "~/softw/penguin/ai/main"
    core.ensure_agents_md(default_path)
    tree.open_tree(default_path)
    slots[1].path = default_path
  end
end, { desc = "Toggle ai main slot" })

-- Tree slot 2 (current project)
vim.keymap.set({ "n", "t" }, "<A-}>", function()
  if slots[2].path then
    tree.open_tree(slots[2].path)
  else
    local project_path = vim.fn.getcwd()
    tree.open_tree(project_path)
    slots[2].path = project_path
  end
end, { desc = "Toggle ai current project" })

-- Tree slot 3 (picker)
vim.keymap.set({ "n", "t" }, "<A-{>", function()
  if slots[3].path then
    tree.open_tree(slots[3].path)
  else
    picker.open_ai_project(3, "tree")
  end
end, { desc = "Toggle ai 3th slot" })

-- New: Alt+' → terminal in current folder (slot 4)
vim.keymap.set({ "n", "t" }, "<A-p>", function()
  if slots[4].path then
    term.toggle_term(slots[4].id)
  else
    local path = tree.get_current_folder_path()
    term.toggle_term(slots[4].id, path)
    slots[4].path = path
  end
end, { desc = "AI slot 4 term (current folder)" })

-- New: Alt+" → file tree in current folder (slot 4)
vim.keymap.set({ "n", "t" }, '<A-P>', function()
  if slots[4].path then
    tree.open_tree(slots[4].path)
  else
    local path = tree.get_current_folder_path()
    tree.open_tree(path)
    slots[4].path = path
  end
end, { desc = "AI slot 4 tree (current folder)" })
