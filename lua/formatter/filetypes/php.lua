local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

M.phpcbf = util.copyf(defaults.phpcbf)
M.php_cs_fixer = util.copyf(defaults.php_cs_fixer)

return M
