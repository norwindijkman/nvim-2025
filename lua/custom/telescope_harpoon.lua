M = {}

local telescope_utils = require("telescope.actions.utils")
local actions = require("telescope.actions")

M.mark_file = function(tb)
  actions.drop_all(tb)
  actions.add_selection(tb)
  telescope_utils.map_selections(tb, function(selection)
    local file = selection[0] or selection
    vim.print(selection)

    -- This lets it work with live grep picker
    if selection.filename then
      file = selection.filename

    -- this lets it work with git status picker
    elseif selection.value then
      file = selection.value
    end

    local harpoon = require("harpoon")
    harpoon:list():add({
      value = file,
      context = {
        row = 1,
        col = 0,
      },
    })
  end)
  actions.remove_selection(tb)
end

return M


