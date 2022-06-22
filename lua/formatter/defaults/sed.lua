local util = require "formatter.util"

return function(pattern, replacement, flags)
  return {
    exe = "sed",
    args = {
      "--in-place",
      util.quote_cmd_arg(util.wrap_sed_replace(pattern, replacement, flags)),
    },
    stdin = false,
  }
end
