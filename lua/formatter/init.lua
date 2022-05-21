local M = {}

local config = require "formatter.config"

function M.setup(o)
  config.set_defaults(o)
end

return M
