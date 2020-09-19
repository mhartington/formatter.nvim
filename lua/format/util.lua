local vim = vim
local util = {}
function util.log(...)
  vim.api.nvim_out_write(table.concat(vim.tbl_flatten {...}) .. "\n")
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
  return s == nil or s == ""
end
return util
