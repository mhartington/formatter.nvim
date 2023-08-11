local M = {}

function M.buf_format()
  return {
    exe = "buf format",
    args = {
      '-w',
    },
    stdin = false,
  }
end

return M
