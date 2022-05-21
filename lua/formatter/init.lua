local M = {}

local config = require "formatter.config"
local util = require "formatter.util"

function M.setup(user_config)
  local is_valid = util.validate_config(user_config)
  if not is_valid then
    util.error "Configuration is not valid"
    return
  end

  config.values = vim.tbl_extend("force", config.values, user_config)
end

return M
