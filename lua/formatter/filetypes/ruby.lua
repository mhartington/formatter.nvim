local M = {}

local util = require "formatter.util"

function M.rubocop()
  return {
    exe = "rubocop",
    args = {
      "--fix-layout",
      "--stdin",
      "$FILE_PATH",
      "--format",
      "files",
      "--stderr",
    },
    stdin = true,
  }
end

function M.standardrb()
  return {
    exe = "standardrb",
    args = {
      "--fix",
      "--format",
      "quiet",
      "--stderr",
      "--stdin",
      "$FILE_PATH",
    },
    stdin = true,
  }
end

return M
