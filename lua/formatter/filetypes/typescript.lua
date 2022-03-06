local M = {}

function M.tsfmt()
	return require("formatter.defaults.tsfmt")()
end

function M.prettier()
	return require("formatter.defaults.prettier")("typescript")
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.prettiereslint()
	return require("formatter.defaults.prettiereslint")("typescript")
end

function M.eslint_d()
	return require("formatter.defaults.eslint_d")()
end

function M.clangformat()
	return require("formatter.defaults.clangformat")()
end

function M.denofmt()
	return require("formatter.defaults.denofmt")()
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

return M
