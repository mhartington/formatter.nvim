local vim = vim

local util = {
  log = function(...)
    vim.api.nvim_out_write(table.concat(vim.tbl_flatten {...}) .. "\n")
  end,
  error = function(...)
    print(table.concat(...))
    vim.api.nvim_error_write(table.concat(vim.tbl_flatten {...}) .. "\n")
  end,
  setLines = function(bufnr, startLine, endLine, lines)
    startLine = startLine - 1 or 0
    endLine = endLine or -1
    return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, true, lines)
  end,
  getLines = function(bufnr, startLine, endLine)
    startLine = startLine - 1 or 0
    endLine = endLine or -1
    return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
  end,
  isEmpty = function(s)
    return s == nil or s == ""
  end
}
return util
