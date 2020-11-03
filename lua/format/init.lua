local vim = vim
local config = require("format.config")
local M = {}
function M.setup(o)
  config.set_defaults(o)
end
return M
