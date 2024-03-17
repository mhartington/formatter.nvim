local util = require "formatter.util"
return function()
  return {
    exe = "ocamlformat",
    args = {
      "--enable-outside-detected-project",
      "$FILE_PATH",
    },
    stdin = true,
  }
end
