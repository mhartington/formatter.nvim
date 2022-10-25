local M = {}

M.dartformat = function(t)
  t = t or {}

  local args = { "--output show" }
  if t.line_length ~= nil then
    table.insert(args, "--line-length " .. t.line_length)
  end

  return {
    exe = "dart format",
    args = args,
    stdin = true,
  }
end

return M
