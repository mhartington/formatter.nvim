local M = {}

function M.prettier()
  return {
    exe = 'prettier',
    args = {
      "--stdin-filepath",
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
  }
end

return M
