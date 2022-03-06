local M = {}

local util = require("formatter.util")

function M.jsbeautify()
  return {
    exe = "js-beautify",
    stdin = true,
    try_node_modules = true,
  }
end

function M.prettydiff()
  return {
    exe = "prettydiff",
    args = {
      util.format_prettydiff_arg("mode", "beautify"),
      util.format_prettydiff_arg("lang", "javascript"),
      util.format_prettydiff_arg("readmethod", "filescreen"),
      util.format_prettydiff_arg("endquietly", "quiet"),
      util.format_prettydiff_arg("source", util.get_current_buffer_file_path()),
    },
    no_append = true,
  }
end

function M.jq()
  return {
    exe = "jq",
    args = ".",
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
    try_node_modules = true,
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

function M.denofmt()
  return {
    exe = "deno",
    args = { "fmt", "-" },
    stdin = true,
  }
end

return M
