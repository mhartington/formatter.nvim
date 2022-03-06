local M = {}

function M.prettydiff()
	return require("formatter.defaults.prettydiff")("css")
end

function M.prettier()
	return require("formatter.defaults.prettier")("css")
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.eslint_d()
	return require("formatter.defaults.eslint_d")()
end

function M.stylefmt()
	return {
		exe = "stylefmt",
		stdin = 1,
		try_node_modules = true,
	}
end

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

return M
