local M = {}

local util = require "formatter.util"

function M.forgefmt()
  return {
    exe = "forge",
    args = { "fmt", "--raw", "-" },
    stdin = true,
  }
end

function M.prettier()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--plugin=prettier-plugin-solidity",
    },
    stdin = true,
    try_node_modules = true,
  }
end

return M
