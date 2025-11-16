local M = {}

local core = require("custom.ai_manager.core")
local term = require("custom.ai_manager.term")
local tree = require("custom.ai_manager.tree")

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

  local path = core.ensure_dir(folder_name)
  core.ensure_agents_md(path)

  local slots = term.get_slots()
  if mode == "term" then
    term.toggle_term(slots[slot].id, path)
  elseif mode == "tree" then
    tree.open_tree(path)
  end

  slots[slot].path = path
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

  local dirs = core.get_dirs()

  pickers.new({}, {
    prompt_title = "Select AI Project Folder",
    finder = finders.new_table({
      results = dirs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
          path = core.base_path .. "/" .. entry .. "/agents.md",
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

return M
