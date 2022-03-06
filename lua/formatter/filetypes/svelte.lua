local M = {}

function M.prettier()
	return require("formatter.defaults.prettier")()
end

return M
