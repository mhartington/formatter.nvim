local vim = vim
local util = {}

function util.log(...)
  vim.api.nvim_out_write(table.concat(vim.tbl_flatten {...}) .. "\n")
end

function util.inspect(val)
  print(vim.inspect(val))
end

function util.error(...)
  print(table.concat(...))
  vim.api.nvim_error_write(table.concat(vim.tbl_flatten {...}) .. "\n")
end

function util.setLines(bufnr, startLine, endLine, lines)
  return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, true, lines)
end

function util.getLines(bufnr, startLine, endLine)
  return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function util.isEmpty(s)
  if type(s) == "table" then
    for k, v in pairs(s) do
      if not util.isEmpty(v) then
        return false
      end
    end
    return true
  end
  return s == nil or s == ""
end

function util.split(s, sep, plain)
  if s ~= "" then
    local t = {}
    for c in vim.gsplit(s, sep, plain) do
      t[c] = true
    end
    return t
  end
end

function util.isSame(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    for k, v in pairs(a) do
      if not util.isSame(b[k], v) then
        return false
      end
    end
    return true
  else
    return a == b
  end
end

return util
