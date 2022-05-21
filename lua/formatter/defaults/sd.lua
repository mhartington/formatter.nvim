local util = require "formatter.util"

return function(pattern, replacement, flags)
  if not flags then
    return {
      exe = "sd",
      args = {
        util.quote_cmd_arg(pattern),
        util.quote_cmd_arg(replacement),
      },
      stdin = false,
    }
  end

  return {
    exe = "sd",
    args = {
      "--flags",
      flags,
      util.quote_cmd_arg(pattern),
      util.quote_cmd_arg(replacement),
    },
    stdin = false,
  }
end
