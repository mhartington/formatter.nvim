local M = {}

function M.prettier()
	return require("formatter.defaults.prettier")("yaml")
end

function M.prettierd()
	return require("formatter.defaults.prettierd")()
end

function M.pyaml()
	return {
		exe = "python3",
		args = { "-m", "pyaml" },
		stdin = true,
	}
end

return M
