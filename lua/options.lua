require "nvchad.options"

vim.opt.shortmess:append("F")
vim.opt.cmdheight = 2

-- Set line wrap on
vim.wo.wrap = false
function ToggleWrap()
  local wrap = vim.wo.wrap
  vim.wo.wrap = not wrap
end
vim.g.indent_blankline_char = ""

-- vim.cmd([[IndentBlanklineRefresh]])

-- Turn line numbers off
vim.wo.number = false

-- Disable swap files
vim.opt.swapfile = false

vim.opt.clipboard = ""

vim.schedule(function()
  vim.opt.showtabline = 0
end)

-- Quickly create a note
local function create_date_file()
  local date_str = os.date "%Y-%m-%d"
  local file_path = "~/softw/penguin/notes/note-" .. date_str .. ".md" -- Change the directory as needed
  local command = "edit " .. file_path
  vim.api.nvim_command(command)
end
vim.api.nvim_create_user_command('CreateDateFile', create_date_file, {})

-- nvim-tree live grep
local function grep_in_nvim_tree_folder()
  local nimvTree = require "nvim-tree.api"
  local node = nimvTree.tree.get_node_under_cursor()
  local path
  if node and node.type == "directory" then
    path = node.absolute_path
  elseif node and node.type == "file" then
    path = vim.fn.fnamemodify(node.absolute_path, ":h")
  end
  if path then
    require("telescope.builtin").live_grep { search_dirs = { path } }
  end
end
vim.api.nvim_create_user_command('GrepInNvimTreeFolder', grep_in_nvim_tree_folder, {})

local function make_recent()
  local filepath = vim.fn.expand('%:p')
  local bufname = vim.fn.bufname()
  -- Check if current buffer is from nvim-tree
  if bufname:match("NvimTree_") then
    local nimvTree = require "nvim-tree.api"
    local node = nimvTree.tree.get_node_under_cursor()
    if node and node.type == "directory" then
      return
    elseif node and node.type == "file" then
      filepath = node.absolute_path
    else
      return
    end
  end
  print(filepath)
  local uri = 'file://' .. filepath
  local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
  local dateCmd = "date --iso-8601=seconds"
  local gioCmd = "gio set -t string " .. filepath .. " metadata::recent-info $(" .. dateCmd .. ")"

  vim.fn.system(gioCmd)

  local new_entry = string.format(
      '  <bookmark href="%s" added="%s" modified="%s" visited="%s">\n' ..
      '    <info>\n' ..
      '      <metadata owner="http://freedesktop.org">\n' ..
      '        <mime:mime-type type="text/plain"/>\n' ..
      '        <bookmark:applications>\n' ..
      '          <bookmark:application name="Neovim" exec="nvim \'%s\'" modified="%s" count="1"/>\n' ..
      '        </bookmark:applications>\n' ..
      '      </metadata>\n' ..
      '    </info>\n' ..
      '  </bookmark>\n',
      uri, timestamp, timestamp, timestamp, filepath, timestamp)

  local recently_used_file = os.getenv("HOME") .. '/.local/share/recently-used.xbel'
  local file = io.open(recently_used_file, "r+")
  if file then
      local content = file:read("*all")
      -- Check if the bookmark already exists
      local escaped_uri = uri:gsub("([^%w])", "%%%1")
      local pattern = '<bookmark href="' .. escaped_uri .. '"[^>]*>.-</bookmark>'
      local exists = content:match(pattern)

      if exists then
          -- Update the existing bookmark
          content = content:gsub(pattern, new_entry)
      else
          -- Insert a new bookmark
          content = content:gsub('</xbel>', new_entry .. '</xbel>')
      end

      file:seek("set")
      file:write(content)
      file:close()
  else
      print("Error: Unable to open recently-used.xbel")
  end
end
vim.api.nvim_create_user_command('MR', make_recent, {})

-- quickly navigte in the current buffer
local function go_to_next_file_in_dir(n)
    local current_file = vim.fn.expand('%:p')
    -- Get all files in the current directory
    local file_pattern = vim.fn.expand('%:h')
    if type(file_pattern) ~= 'string' then
      return
    end

    local files_unsorted = {}
    local siblings = vim.fn.globpath(file_pattern, '*', false, true)
    for _, sibling in ipairs(siblings) do
      if vim.fn.isdirectory(sibling) == 0 then
        table.insert(files_unsorted, sibling)
      end
    end

    -- if current file is an unsaves swapfile, add it to files_unsorted
    if vim.loop.fs_stat(current_file) == nil then
      table.insert(files_unsorted, current_file)
    end

    -- Sort the files alphabetically
    local files = vim.fn.sort(files_unsorted)

    -- Find the current file and determine the next file to edit
    local next_file_index = nil
    for i, file in ipairs(files) do
        if file == current_file then
            next_file_index = (i+n-1) % #files + 1
            break
        end
    end

    if next_file_index then
        -- Edit the next file
        vim.cmd('edit ' .. vim.fn.fnameescape(files[next_file_index]))
    end
end
local function go_to_next_file_in_dir_wrapper()
    go_to_next_file_in_dir(1)
end
local function go_to_prev_file_in_dir_wrapper()
    go_to_next_file_in_dir(-1)
end

vim.api.nvim_create_user_command('NextFile', go_to_next_file_in_dir_wrapper, {})
vim.api.nvim_create_user_command('PrevFile', go_to_prev_file_in_dir_wrapper, {})

vim.o.scrolloff = 999

local function closeOtherBufs (c_buf)
  for _, buf in ipairs(vim.t.bufs) do
    if buf ~=  c_buf then
      require('nvchad.tabufline').close_buffer(buf)
    end
  end
end

vim.api.nvim_create_user_command("BufCloseOther", function()
  closeOtherBufs(vim.api.nvim_get_current_buf())
end, {})
