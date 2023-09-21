local M = {}

-- TODO: better way to join paths
M.path_separator = (function()
  local jit = require "jit"
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

function M.create(buffer_path, content, options)
  local buffer_dir = vim.fn.fnamemodify(buffer_path, ":h")
  local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")

  local filename
  if type(options.tempfile_postfix) == "string" then
    filename = ("%s_%d_%s_%s"):format(
      options.tempfile_prefix or "~formatter",
      math.random(1, 1000000),
      buffer_name,
      options.tempfile_postfix
    )
  else
    filename = ("%s_%d_%s"):format(
      options.tempfile_prefix or "~formatter",
      math.random(1, 1000000),
      buffer_name
    )
  end

  local path = (options.tempfile_dir or buffer_dir)
    .. M.path_separator
    .. filename

  local tempfile = io.open(path, "w+")
  if not tempfile then
    return nil
  end

  for _, line in pairs(content) do
    tempfile:write(line .. "\n")
  end
  tempfile:flush()
  tempfile:close()

  return path
end

function M.read(path)
  local tempfile = io.open(path, "r")
  if tempfile == nil then
    return
  end
  local lines = {}
  for line in tempfile:lines() do
    lines[#lines + 1] = line
  end
  tempfile:close()

  return lines
end

return M
