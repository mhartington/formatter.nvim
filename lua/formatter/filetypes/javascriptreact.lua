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

function M.esformatter()
  return {
    exe = "esformatter",
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

function M.prettiereslint()
  return {
    exe = "prettier-eslint",
    args = {
      "--stdin",
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.eslint_d()
  return {
    exe = "eslint_d",
    args = {
      "--stdin",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_path()),
      "--fix-to-stdout",
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.standard()
  return {
    exe = "standard",
    args = { "--stdin", "--fix" },
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

function M.semistandard()
  return {
    exe = "semistandard",
    args = { "--stdin", "--fix" },
    stdin = true,
    try_node_modules = true,
  }
end

return M
