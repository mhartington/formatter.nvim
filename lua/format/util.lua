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
    return vim.api.nvim_buf_set_lines(bufnr, startLine-1, endLine, true, lines)
  end,
  getLines = function(bufnr, startLine, endLine)
    return vim.api.nvim_buf_get_lines(bufnr, startLine-1, endLine, true)
  end,
  isEmpty = function(s)
    return s == nil or s == ""
  end,
  Set = function(list)
    local set = {}
    for _, l in ipairs(list) do
      set[l] = true
    end
    return set
  end
}
return util
