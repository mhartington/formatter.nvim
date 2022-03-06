local M = {}

local util = require("formatter.util")

function M.jsbeautify()
	return require("formatter.defaults.jsbeautify")()
end

function M.prettydiff()
	return require("formatter.defaults.prettydiff")("javascript")
end

function M.prettier()
	return require("formatter.defaults.prettier")()
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.denofmt()
	return require("formatter.defaults.denofmt")()
end

function M.jq()
	return {
		exe = "jq",
		args = ".",
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

return M
