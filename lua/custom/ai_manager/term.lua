local M = {}

-- Keep track of up to 4 terminals
local term_slots = {
  { id = "ai-term-1", created = false, path = nil },
  { id = "ai-term-2", created = false, path = nil },
  { id = "ai-term-3", created = false, path = nil },
  { id = "ai-term-4", created = false, path = nil },
}

function M.get_slots()
  return term_slots
end

-- Toggle a terminal by id. If path is provided, create and open in that path
function M.toggle_term(id, path)
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

return M
