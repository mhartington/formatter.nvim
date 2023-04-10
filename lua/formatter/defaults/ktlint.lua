local util = require "formatter.util"

return function()
    return {
        exe = "ktlint",
        args = {
            "--stdin",
            "--format",
            "--log-level=none"
        },
        stdin = true
    }
end
