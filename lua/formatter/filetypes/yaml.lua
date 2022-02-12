local M = {}

local util = require("formatter.util")

function M.pyaml()
  return {
    exe = "python3",
    args = { "-m", "pyaml" },
    stdin = true,
  }
end

function M.prettier()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--parser",
      "yaml",
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.prettierd()
  return {
    exe = "prettierd",
    args = { util.get_current_buffer_file_path() },
    stdin = 1,
  }
end

return M
