local M = {}

local util = require("formatter.util")

function M.tidy()
  return {
    exe = "tidy",
    args = { "-quiet" },
    try_node_modules = true,
  }
end

function M.prettier()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.prettierd()
  return {
    exe = "prettierd",
    args = { util.escape_path(util.get_current_buffer_file_path()) },
    stdin = true,
  }
end

function M.htmlbeautify()
  return {
    exe = "html-beautify",
    stdin = 1,
  }
end

function M.prettydiff()
  return {
    exe = "prettydiff",
    args = {
      util.format_prettydiff_arg("mode", "beautify"),
      util.format_prettydiff_arg("lang", "html"),
      util.format_prettydiff_arg("readmethod", "filescreen"),
      util.format_prettydiff_arg("endquietly", "quiet"),
      util.format_prettydiff_arg("source", util.get_current_buffer_file_path()),
    },
    no_append = true,
  }
end

return M
