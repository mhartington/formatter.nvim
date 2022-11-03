local M = {}

local util = require "formatter.util"

function M.rubocop()
  return {
    exe = "rubocop",
    args = {
      "--fix-layout",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_name()),
      "--format",
      "files",
    },
    stdin = true,
    transform = function(text)
      table.remove(text, 1)
      table.remove(text, 1)
      return text
    end,
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
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

return M
