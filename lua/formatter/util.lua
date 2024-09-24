local M = {}
local config = require "formatter.config"

-- NOTE: to contributors
-- NOTE: use these for "lua/formatter/defaults" and "lua/formatter/filetypes"

function M.get_cwd()
  return vim.fn.getcwd()
end

function M.get_current_buffer_file_path()
  return vim.api.nvim_buf_get_name(0)
end

function M.get_current_buffer_file_name()
  return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":t")
end

function M.get_current_buffer_file_dir()
  return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":h")
end

function M.get_current_buffer_file_extension()
  return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":e")
end

function M.quote_cmd_arg(arg)
  return string.format("'%s'", arg)
end

-- TODO: check fnameescape or shellescape?
function M.escape_path(arg)
  return vim.fn.shellescape(arg, true)
end

function M.wrap_sed_replace(pattern, replacement, flags)
  return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

-- TODO: check that this is okay for paths and ordinary strings
function M.format_prettydiff_arg(name, value)
  return string.format('%s:"%s"', name, value)
end

-- Returns a list of currently available formatters for the specified filetype.
function M.get_available_formatters_for_ft(ft)
  local available_formatters = {}
  local user_defined_formatters = config.values.filetype

  for formatter_filetype, formatter_functions in pairs(user_defined_formatters) do
    if ft == "*" or ft == formatter_filetype then
      for _, formatter_function in ipairs(formatter_functions) do
        local formatter_info = formatter_function()
        table.insert(available_formatters, formatter_info)
      end
    end
  end

  return available_formatters
end

-- NOTE: to contributors
-- NOTE: use these for "lua/formatter/filetypes"

function M.withl(f, ...)
  local argsl = { ... }
  return function(...)
    local argsr = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function M.withr(f, ...)
  local argsr = { ... }
  return function(...)
    local argsl = { ... }
    return f(unpack(argsl), unpack(argsr))
  end
end

function M.copyf(f)
  return function(...)
    return f(...)
  end
end

-----------------------------------------------------------------------------
-- Tables

function M.is_empty(s)
  if type(s) == "table" then
    for _, v in pairs(s) do
      if not M.is_empty(v) then
        return false
      end
    end
    return true
  end
  return s == nil or s == ""
end

function M.split(s, sep, plain)
  if s ~= "" then
    local t = {}
    for c in vim.gsplit(s, sep, plain) do
      t[c] = true
    end
    return t
  end
end

function M.is_same(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    if #a ~= #b then
      return false
    end
    for k, v in pairs(a) do
      if not M.is_same(b[k], v) then
        return false
      end
    end
    return true
  else
    return a == b
  end
end

function M.tbl_slice(tbl, start_idx, end_idx)
  local ret = {}
  if not start_idx then
    start_idx = 1
  end
  if not end_idx then
    end_idx = #tbl
  end
  for i = start_idx, end_idx do
    table.insert(ret, tbl[i])
  end
  return ret
end

-----------------------------------------------------------------------------
-- Vim

function M.set_lines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

local function common_prefix_len(a, b)
  if not a or not b then
    return 0
  end
  local min_len = math.min(#a, #b)
  for i = 1, min_len do
    if string.byte(a, i) ~= string.byte(b, i) then
      return i - 1
    end
  end
  return min_len
end

local function common_suffix_len(a, b)
  local a_len = #a
  local b_len = #b
  local min_len = math.min(a_len, b_len)
  for i = 0, min_len - 1 do
    if string.byte(a, a_len - i) ~= string.byte(b, b_len - i) then
      return i
    end
  end
  return min_len
end

local function create_text_edit(
  original_lines,
  replacement,
  is_insert,
  is_replace,
  orig_line_start,
  orig_line_end
)
  local start_line, end_line = orig_line_start - 1, orig_line_end - 1
  local start_char, end_char = 0, 0
  if is_replace then
    -- If we're replacing text, see if we can avoid replacing the entire line
    start_char =
      common_prefix_len(original_lines[orig_line_start], replacement[1])
    if start_char > 0 then
      replacement[1] = replacement[1]:sub(start_char + 1)
    end

    if original_lines[orig_line_end] then
      local last_line = replacement[#replacement]
      local suffix = common_suffix_len(original_lines[orig_line_end], last_line)
      -- If we're only replacing one line, make sure the prefix/suffix calculations don't overlap
      if orig_line_end == orig_line_start then
        suffix =
          math.min(suffix, original_lines[orig_line_end]:len() - start_char)
      end
      end_char = original_lines[orig_line_end]:len() - suffix
      if suffix > 0 then
        replacement[#replacement] = last_line:sub(1, last_line:len() - suffix)
      end
    end
  end
  -- If we're inserting text, make sure the text includes a newline at the end.
  -- The one exception is if we're inserting at the end of the file, in which case the newline is
  -- implicit
  if is_insert and start_line < #original_lines then
    table.insert(replacement, "")
  end
  local new_text = table.concat(replacement, "\n")

  return {
    newText = new_text,
    range = {
      start = {
        line = start_line,
        character = start_char,
      },
      ["end"] = {
        line = end_line,
        character = end_char,
      },
    },
  }
end

function M.update_lines(bufnr, original_lines, new_lines)
  -- Update lines based on diffs. This is based (copied) from conform with some edits
  table.insert(original_lines, "")
  table.insert(new_lines, "")
  local original_text = table.concat(original_lines, "\n")
  local new_text = table.concat(new_lines, "\n")
  table.remove(original_lines)
  table.remove(new_lines)

  if new_text:match "^%s*$" and not original_text:match "^%s*$" then
    return false
  end

  ---@diagnostic disable-next-line: missing-fields
  local indices = vim.diff(original_text, new_text, {
    result_type = "indices",
    algorithm = "histogram",
  })
  assert(type(indices) == "table")
  local text_edits = {}
  for _, idx in ipairs(indices) do
    local orig_line_start, orig_line_count, new_line_start, new_line_count =
      unpack(idx)
    local is_insert = orig_line_count == 0
    local is_delete = new_line_count == 0
    local is_replace = not is_insert and not is_delete
    local orig_line_end = orig_line_start + orig_line_count
    local new_line_end = new_line_start + new_line_count

    if is_insert then
      orig_line_start = orig_line_start + 1
      orig_line_end = orig_line_end + 1
    end

    local replacement = M.tbl_slice(new_lines, new_line_start, new_line_end - 1)

    if is_replace then
      orig_line_end = orig_line_end - 1
    end
    local text_edit = create_text_edit(
      original_lines,
      replacement,
      is_insert,
      is_replace,
      orig_line_start,
      orig_line_end
    )
    table.insert(text_edits, text_edit)
  end

  vim.lsp.util.apply_text_edits(text_edits, bufnr, "utf-8")

  return not vim.tbl_isempty(text_edits)
end

function M.get_lines(bufnr, startLine, endLine)
  return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, false)
end

function M.fire_event(event, silent)
  local cmd = string.format(
    "%s doautocmd <nomodeline> User %s",
    silent and "silent" or "",
    event
  )
  vim.api.nvim_command(cmd)
end

function M.get_buffer_variable(buf, var)
  local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
  if status then
    return result
  end
  return nil
end

--- get a table that maps a window to a view
---@see vim.fn.winsaveview()
function M.get_views_for_this_buffer()
  local windows_containing_this_buffer = vim.fn.win_findbuf(vim.fn.bufnr())
  local window_to_view = {}
  for _, w in ipairs(windows_containing_this_buffer) do
    vim.api.nvim_win_call(w, function()
      window_to_view[w] = vim.fn.winsaveview()
    end)
  end
  return window_to_view
end

--- restore view for each window
---@param window_to_view table maps window to a view
---@see vim.fn.winrestview()
function M.restore_view_per_window(window_to_view)
  for w, view in pairs(window_to_view) do
    if vim.api.nvim_win_is_valid(w) then
      vim.api.nvim_win_call(w, function()
        vim.fn.winrestview(view)
      end)
    end
  end
end

--- Find the closest node_modules path
function M.find_node_modules(dir)
  for p in vim.fs.parents(vim.fs.normalize(dir) .. "/") do
    local node_modules = p .. "/node_modules"
    if vim.fn.isdirectory(node_modules) == 1 then
      return node_modules
    end
  end
end

function M.get_node_modules_bin_path(node_modules)
  if not node_modules then
    return nil
  end

  local bin_path = node_modules .. "/.bin"
  if vim.fn.isdirectory(bin_path) ~= 1 then
    return nil
  end
  return bin_path
end

if vim.fn.has "win32" == 1 then
  M.path_separator = ";"
else
  M.path_separator = ":"
end

return M
