local M = {}

local util = require "formatter.util"

function M.luaformatter()
  return {
    exe = "luaformatter",
  }
end

function M.luafmt()
  return {
    exe = "luafmt",
    args = { "--stdin" },
    stdin = true,
  }
end

function M.luaformat()
  return {
    exe = "lua-format",
    args = {util.escape_path(util.get_current_buffer_file_path())},
    stdin = true
  }
end

function M.stylua()
  return {
    exe = "stylua",
    args = {
      "--search-parent-directories",
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--",
      "-",
    },
    stdin = true,
  }
end

return M
