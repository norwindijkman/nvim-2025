local M = {}

M.base_path = vim.fn.expand("~/softw/penguin/ai")

M.template = [[
# Agents

## Overview
Describe your AI agents here.

## Details
- Purpose:
- Inputs:
- Outputs:
- Notes:
]]

-- Helper: get subdirectories under base_path
function M.get_dirs()
  local handle = io.popen('ls -d ' .. M.base_path .. '/*/ 2>/dev/null')
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

-- Helper: create directory if needed inside base_path
function M.ensure_dir(name)
  local path = M.base_path .. "/" .. name
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
  return path
end

-- Helper: ensure agents.md exists in provided path
function M.ensure_agents_md(path)
  local dir = vim.fn.expand(path)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p") -- 'p' creates parent directories if needed
  end

  local file = dir .. "/agents.md"

  if vim.fn.filereadable(file) == 0 then
    local f = io.open(file, "w")
    if f then
      f:write(M.template)
      f:close()
    else
      error("Could not create file: " .. file)
    end
  end

  return file
end

return M
