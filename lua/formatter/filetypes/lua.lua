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
    args = {"$FILE_PATH"},
    stdin = true
  }
end

function M.stylua()
  return {
    exe = "stylua",
    args = {
      "--search-parent-directories",
      "--stdin-filepath",
      "$FILE_PATH",
      "--",
      "-",
    },
    stdin = true,
  }
end

return M
