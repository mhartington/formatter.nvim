local M = {}

function M.clangformat()
    return {
        exe = "clang-format",
        args = {"--style=Google", "--assume-filename=.java"},
        stdin = true
    }
end

return M
