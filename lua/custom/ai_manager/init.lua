local M = {}

local base_path = vim.fn.expand("~/softw/penguin/ai")
local template = [[
# Agents

## Overview
Describe your AI agents here.

## Details
- Purpose:
- Inputs:
- Outputs:
- Notes:
]]

-- Keep track of up to 3 terminals
local term_slots = {
  {
    id = "ai-term-1",
    created = false,
    path = nil,
  },
  {
    id = "ai-term-2",
    created = false,
    path = nil,
  },
  {
    id = "ai-term-3",
    created = false,
    path = nil,
  },
}

-- Helper: get subdirectories
local function get_dirs()
  local handle = io.popen('ls -d ' .. base_path .. '/*/ 2>/dev/null')
  if not handle then return {} end
  local result = {}
  for dir in handle:lines() do
    local clean_dir = dir:gsub("/$", "")
    local name = vim.fn.fnamemodify(clean_dir, ":t")
    if name ~= "" then
      table.insert(result, name)
    end
  end
  handle:close()
  table.insert(result, 1, "🆕 Create new folder")
  return result
end

-- Helper: create directory if needed
local function ensure_dir(name)
  local path = base_path .. "/" .. name
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
  return path
end

-- Helper: ensure agents.md exists
local function ensure_agents_md(path)
  local dir = vim.fn.expand(path)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")  -- 'p' creates parent directories if needed
  end

  local file = dir .. "/agents.md"

  -- Create the file if it doesn't exist
  if vim.fn.filereadable(file) == 0 then
    local f = io.open(file, "w")
    if f then
      f:write(template)
      f:close()
    else
      error("Could not create file: " .. file)
    end
  end

  return file
end

local function toggle_term(id, path)
  local cmd = path and ("mkdir -p " .. path .. ' && cd ' .. path .. ' && opencode .') or nil
  require("nvchad.term").toggle {
    id = id,
    pos = "float",
    cmd = cmd,
    float_opts = {
      relative = "editor",
      row = 0,
      col = 0,
      width = 1,
      height = 0.95,
      border = "none",
    },
  }
end

local function open_tree(path)
  local api = require("nvim-tree.api")
  if api.tree.is_visible() then
    api.tree.change_root(path)
  else
    api.tree.open({ path = path })
  end
end

-- Open selected or created folder
function M.open_project(folder_name, slot, mode)
  if not folder_name or folder_name == "" then return end

  if folder_name == "🆕 Create new folder" then
    vim.ui.input({ prompt = "Enter new folder name: " }, function(input)
      if not input or input == "" then return end
      M.open_project(input, slot, mode)
    end)
    return
  end

  local path = ensure_dir(folder_name)
  local agents_file = ensure_agents_md(path)

  if mode == "term" then
    toggle_term(term_slots[slot].id, path)
  elseif mode == "tree" then
    open_tree(path)
  end

  term_slots[slot].path = path
end

-- Telescope picker with preview
function M.open_ai_project(slot, mode)
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope is not installed", vim.log.levels.ERROR)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local previewers = require("telescope.previewers")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local dirs = get_dirs()

  pickers.new({}, {
    prompt_title = "Select AI Project Folder",
    finder = finders.new_table({
      results = dirs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
          path = base_path .. "/" .. entry .. "/agents.md",
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "agents.md Preview",
      define_preview = function(self, entry)
        if entry.value == "🆕 Create new folder" then
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Create a new AI project folder..." })
          return
        end
        local path = entry.path
        if vim.fn.filereadable(path) == 0 then
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "No agents.md found." })
        else
          local lines = vim.fn.readfile(path)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      local function open_selected()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.open_project(selection.value, slot, mode)
      end
      map("i", "<CR>", open_selected)
      map("n", "<CR>", open_selected)
      return true
    end,
  }):find()
end

-- Key mappings
vim.keymap.set("n", "<leader>ai", M.open_ai_project, { desc = "Open AI project manager" })

-- Open terminal
vim.keymap.set({ "n", "t" }, "<A-\\>", function()
  if term_slots[1].path then
    toggle_term(term_slots[1].id)
  else
    local default_path = "~/softw/penguin/ai/main"
    ensure_agents_md(default_path)
    toggle_term(term_slots[1].id, default_path)
    term_slots[1].path = default_path
  end
end, { desc = "Toggle ai main slot" })
vim.keymap.set({ "n", "t" }, "<A-]>", function()
  if term_slots[2].path then
    toggle_term(term_slots[2].id)
  else
    M.open_ai_project(2, "term")
  end
end, { desc = "Toggle ai 2th slot" })
vim.keymap.set({ "n", "t" }, "<A-[>", function()
  if term_slots[3].path then
    toggle_term(term_slots[3].id)
  else
    M.open_ai_project(3, "term")
  end
end, { desc = "Toggle ai 3th slot" })

-- Open file tree
vim.keymap.set({ "n", "t" }, "<A-|>", function()
  if term_slots[1].path then
    open_tree(term_slots[1].path)
  else
    local default_path = "~/softw/penguin/ai/main"
    ensure_agents_md(default_path)
    open_tree(default_path)
    term_slots[1].path = default_path
  end
end, { desc = "Toggle ai main slot" })
vim.keymap.set({ "n", "t" }, "<A-}>", function()
  if term_slots[2].path then
    open_tree(term_slots[2].path)
  else
    M.open_ai_project(2, "tree")
  end
end, { desc = "Toggle ai 2th slot" })
vim.keymap.set({ "n", "t" }, "<A-{>", function()
  if term_slots[3].path then
    open_tree(term_slots[3].path)
  else
    M.open_ai_project(3, "tree")
  end
end, { desc = "Toggle ai 3th slot" })

return M
