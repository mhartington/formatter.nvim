local M = {}

function M.ktlint()
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

return M
