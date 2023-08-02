local M = {}

local util = require "formatter.util"

function M.rubocop()
  return {
    exe = "rubocop",
    args = {
      "--fix-layout",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_path()),
      "--format",
      "files",
      "--stderr",
    },
    stdin = true,
  }
end

function M.rubocop_with_unsafe()
  return {
    exe = "rubocop",
    args = {
      "-A",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_path()),
      "--format",
      "files",
      "--stderr",
    },
    stdin = true,
  }
end

function M.bundle_rubocop()
  return {
    exe = "bundle",
    args = {
      "exec",
      "rubocop",
      "--fix-layout",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_path()),
      "--format",
      "files",
      "--stderr",
    },
    stdin = true,
  }
end

function M.bundle_rubocop_with_unsafe()
  return {
    exe = "bundle",
    args = {
      "exec",
      "rubocop",
      "-A",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_path()),
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
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

return M
