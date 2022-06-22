local M = {}

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
  return vim.fn.fnameescape(arg)
end

function M.wrap_sed_replace(pattern, replacement, flags)
  return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

-- TODO: check that this is okay for paths and ordinary strings
function M.format_prettydiff_arg(name, value)
  return string.format('%s:"%s"', name, value)
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

-----------------------------------------------------------------------------
-- Vim

function M.set_lines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

function M.get_lines(bufnr, startLine, endLine)
  return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function M.fire_event(event)
  local cmd = string.format("silent doautocmd <nomodeline> User %s", event)
  vim.api.nvim_command(cmd)
end

function M.get_buffer_variable(buf, var)
  local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
  if status then
    return result
  end
  return nil
end

return M
