local M = {}

function M.jsbeautify()
	return require("formatter.defaults.jsbeautify")()
end

function M.prettydiff()
	return require("formatter.defaults.prettydiff")("javascript")
end

function M.esformatter()
	return require("formatter.defaults.esformatter")()
end

function M.prettier()
	return require("formatter.defaults.prettier")()
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.prettiereslint()
	return require("formatter.defaults.prettiereslint")()
end

function M.eslint_d()
	return require("formatter.defaults.eslint_d")()
end

function M.standard()
	return require("formatter.defaults.standard")()
end

function M.denofmt()
	return require("formatter.defaults.denofmt")()
end

function M.semistandard()
	return require("formatter.defaults.semistandard")()
end

function M.clangformat()
	return require("formatter.defaults.clangformat")()
end

return M
