local M = {}

function M.stylua()
  return {
    exe = 'stylua',
    args = {
      '--search-parent-directories',
      '--stdin-filepath',
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
      '--',
      '-'
    }
  }
end

return M
