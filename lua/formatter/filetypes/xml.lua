local defaults = require "formatter.defaults"
local util = require "formatter.util"

local M = {}

function M.tidy()
  return {
    exe = "tidy",
    args = {
      "-quiet",
      "-xml",
      "--indent auto",
      "--indent-spaces 2",
      "--vertical-space yes",
      "--tidy-mark no",
    },
    stdin = true,
    try_node_exe = true,
  }
end

function M.xmllint()
  return {
    exe = "xmllint",
    args = {
      "--format",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

M.xmlformat = util.copyf(defaults.xmlformat)

return M
