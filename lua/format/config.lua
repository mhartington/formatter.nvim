local vim = vim
_FormatterConfigurationValues = _FormatterConfigurationValues or {}

local config = {
  values = _FormatterConfigurationValues,
  set_defaults = function(defaults)
    defaults = defaults or {}
    config.values = defaults
  end
}

config.set_defaults()

return config
