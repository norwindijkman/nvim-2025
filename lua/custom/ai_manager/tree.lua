local M = {}

-- Open nvim-tree at a given path, or change root if already open
function M.open_tree(path)
  local api = require("nvim-tree.api")
  if api.tree.is_visible() then
    api.tree.change_root(path)
  else
    api.tree.open({ path = path })
  end
end

-- Resolve current folder from NvimTree node under cursor, else fallback to cwd
function M.get_current_folder_path()
  local ok, api = pcall(require, "nvim-tree.api")
  if ok and vim.bo.filetype == "NvimTree" then
    local node = api.tree.get_node_under_cursor()
    if node then
      if node.type == "directory" then
        return node.absolute_path
      elseif node.type == "file" then
        return vim.fn.fnamemodify(node.absolute_path, ":h")
      end
    end
  end
  return vim.fn.getcwd()
end

return M
