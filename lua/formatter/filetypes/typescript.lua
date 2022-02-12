local M = {}

local util = require("formatter.util")

-- TODO: a bit different than neoformat, so should chack that it works
function M.tsfmt()
  return {
    exe = "tsfmt",
    args = {
      "--stdin",
      "--baseDir",
      util.escape_path(util.get_cwd()),
    },
    stdin = true,
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
      "typescript",
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.prettierd()
  return {
    exe = "prettierd",
    args = {
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = 1,
  }
end

function M.prettiereslint()
  return {
    exe = "prettier-eslint",
    args = {
      "--stdin",
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--parser",
      "typescript",
    },
    stdin = true,
    try_node_modules = true,
  }
end

-- NOTE: tslint is deprecated, so I don't want to add it here from neoformat
-- function M.tslint()
--   local args = { "--fix", "--force" }
--
--   if vim.fn.filereadable("tslint.json") then
--     args = { "-c", "tslint.json" }
--   end
--
--   return {
--     exe = "tslint",
--     args = args,
--     try_node_modules = true,
--   }
-- end

function M.eslint_d()
  return {
    exe = "eslint_d",
    args = {
      "--stdin",
      "--stdin-filename",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.clangformat()
  return {
    exe = "clang-format",
    args = {
      "-assume-filename=" .. util.escape_path(
        util.get_current_buffer_file_name()
      ),
    },
    stdin = true,
    try_node_modules = true,
  }
end

function M.denoformat()
  return {
    exe = "deno",
    args = { "fmt", "-" },
    stdin = true,
  }
end

return M
