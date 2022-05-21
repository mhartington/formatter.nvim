local M = {}

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

return M
