local util = require "formatter.util"

-- TODO: a bit different than neoformat, so should chack that it works
return function()
  return {
    exe = "tsfmt",
    args = {
      "--stdin",
      "--baseDir",
      util.escape_path(util.get_cwd()),
    },
    stdin = true,
    try_node_modules = true,
  }
end
