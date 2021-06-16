_FormatterConfigurationValues = _FormatterConfigurationValues or {}

local config = {}
config.values = _FormatterConfigurationValues

function config.set_defaults(user_opts)
  config.values = vim.tbl_extend('force', { filetype = {}}, user_opts)
end

config.set_defaults({})

return config
