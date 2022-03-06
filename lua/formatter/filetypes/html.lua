local M = {}

function M.prettier()
	return require("formatter.defaults.prettier")()
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.prettydiff()
	return require("formatter.defaults.prettydiff")("html")
end

function M.tidy()
	return {
		exe = "tidy",
		args = { "-quiet" },
		try_node_modules = true,
	}
end

function M.htmlbeautify()
	return {
		exe = "html-beautify",
		stdin = 1,
	}
end

return M
