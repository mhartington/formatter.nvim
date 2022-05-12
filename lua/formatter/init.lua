local config = require "formatter.config"

local M = {}

function M.setup(o)
  config.set_defaults(o)
end

return M
