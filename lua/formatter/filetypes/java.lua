local M = {}

local util = require "formatter.util"

function M.clangformat()
    return {
        exe = "clang-format",
        args = {"--style=Google", "--assume-filename=.java"},
        stdin = true
    }
end

function M.google_java_format()
    return {
        exe = "google-java-format",
        args = {
            "--aosp",
            util.escape_path(util.get_current_buffer_file_path()),
            "--replace"
        },
        stdin = true
    }
end

return M
