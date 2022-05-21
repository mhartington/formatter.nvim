local M = {}

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

function M.create(bufname, input, opts)
  local split_bufname = vim.split(bufname, M.path_separator)
  local prefix = opts.tempfile_prefix or "~formatting"
  local suffix = opts.tempfile_postfix or ""
  local filename = ("%s_%d_%s%s"):format(
    prefix,
    math.random(1, 1000000),
    split_bufname[#split_bufname],
    suffix
  )

  split_bufname[#split_bufname] = nil
  local tempfile_dir = table.concat(split_bufname, M.path_separator)
  if tempfile_dir == "" then
    tempfile_dir = "."
  end
  local path = ("%s/%s"):format((opts.tempfile_dir or tempfile_dir), filename)

  local tempfile = io.open(path, "w+")
  if not tempfile then
    return nil
  end

  for _, line in pairs(input) do
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
