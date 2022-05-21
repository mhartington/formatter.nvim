local M = {}

local config = require "formatter.config"
local log = require "formatter.log"

function M.setup(user_config)
  if not config.validate_config(user_config) then
    log.error "Configuration is not valid"
    return
  end

  config.values = config.normalize_config(user_config)
end

return M
