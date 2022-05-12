local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.tsfmt = util.copyf(defaults.tsfmt)

M.prettier = util.withl(defaults.prettier, "typescript")

M.prettierd = util.copyf(defaults.prettierd)

M.prettiereslint = util.withl(defaults.prettiereslint, "typescript")

M.eslint_d = util.copyf(defaults.eslint_d)

M.clangformat = util.copyf(defaults.clangformat)

M.denofmt = util.copyf(defaults.denofmt)

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

return M
