local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.jsbeautify = util.copyf(defaults.jsbeautify)

M.prettydiff = util.withl(defaults.prettydiff, "javascript")

M.prettier = util.copyf(defaults.prettier)

M.prettierd = util.copyf(defaults.prettierd)

M.denofmt = util.copyf(defaults.denofmt)

M.biome = util.copyf(defaults.biome)

function M.jq()
  return {
    exe = "jq",
    args = { "." },
    stdin = true,
  }
end

function M.fixjson()
  return {
    exe = "fixjson",
    args = { "--stdin-filename", util.get_current_buffer_file_name() },
    stdin = true,
    try_node_modules = true,
  }
end

return M
