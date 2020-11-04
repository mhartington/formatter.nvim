local vim = vim
local util = {}

function util.log(...)
  vim.api.nvim_out_write("Formatter: " .. table.concat(vim.tbl_flatten {...}) .. "\n")
end

function util.error(...)
  vim.api.nvim_err_write(table.concat(vim.tbl_flatten {...}) .. "\n")
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

function util.fireEvent(event)
  local cmd = string.format("silent doautocmd <nomodeline> User %s", event)
  vim.api.nvim_command(cmd)
end
return util
