local M = {}

function M.uncrustify()
	return require("formatter.defaults.uncrustify")("C")
end

function M.clangformat()
	return require("formatter.defaults.clangformat")()
end

function M.astyle()
	return require("formatter.defaults.astyle")("c")
end

return M
