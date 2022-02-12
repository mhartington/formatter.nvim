local M = {}

local util = require("formatter.util")

function M.uncrustify()
  return {
    exe = "uncrustify",
    args = { "-q", "-l C" },
    stdin = true,
  }
end

function M.clangformat()
  return {
    exe = "clang-format",
    args = {
      "-assume-filename",
      util.escape_path(util.get_current_buffer_file_name()),
    },
    stdin = true,
  }
end

function M.astyle()
  return {
    exe = "astyle",
    args = { "--mode=c" },
    stdin = true,
  }
end

return M
