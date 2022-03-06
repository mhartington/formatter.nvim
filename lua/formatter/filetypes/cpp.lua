local M = {}

function M.uncrustify()
	return require("formatter.defaults.uncrustify")("CPP")
end

function M.clangformat()
	return require("formatter.defaults.clangformat")()
end

function M.astyle()
	return require("formatter.defaults.astyle")("c")
end

return M
