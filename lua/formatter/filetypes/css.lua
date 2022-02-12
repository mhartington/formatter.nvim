local M = {}

local util = require("formatter.util")

function M.cssbeautify()
  return {
    exe = "css-beautify",
    stdin = 1,
  }
end

function M.csscomb()
  return {
    exe = "csscomb",
    try_node_modules = true,
  }
end

function M.prettydiff()
  return {
    exe = "prettydiff",
    args = {
      util.format_prettydiff_arg("mode", "beautify"),
      util.format_prettydiff_arg("lang", "css"),
      util.format_prettydiff_arg("readmethod", "filescreen"),
      util.format_prettydiff_arg("endquietly", "quiet"),
      util.format_prettydiff_arg("source", util.get_current_buffer_file_path()),
    },
    no_append = true,
  }
end

function M.stylefmt()
  return {
    exe = "stylefmt",
    stdin = 1,
    try_node_modules = true,
  }
end

function M.prettier()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--parser",
      "css",
    },
    stdin = true,
  }
end

function M.prettierd()
  return {
    exe = "prettierd",
    args = { util.escape_path(util.get_current_buffer_file_path()) },
    stdin = true,
  }
end

function M.eslint_d()
  return {
    exe = "eslint_d",
    args = {
      "--fix",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_name()),
    },
    stdin = true,
    try_node_modules = true,
  }
end

return M
