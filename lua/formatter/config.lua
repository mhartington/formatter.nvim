_FormatterConfigurationValues = _FormatterConfigurationValues or {}

local config = {}
config.values = _FormatterConfigurationValues

function config.set_defaults(defaults)
  defaults = defaults or {}
  config.values = vim.tbl_extend("force", { filetype = {} }, defaults)
end

config.set_defaults()

return config
