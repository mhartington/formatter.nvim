local M = {}

local config = require("formatter.config")

-- NOTE: to contributors
-- NOTE: use these for "lua/formatter/defaults" and "lua/formatter/filetypes"

function M.get_cwd()
    return vim.fn.getcwd()
end

function M.get_current_buffer_file_path()
    return vim.api.nvim_buf_get_name(0)
end

function M.get_current_buffer_file_name()
    return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":t")
end

function M.get_current_buffer_file_dir()
    return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":h")
end

function M.get_current_buffer_file_extension()
    return vim.fn.fnamemodify(M.get_current_buffer_file_path(), ":e")
end

function M.quote_cmd_arg(arg)
    return string.format("'%s'", arg)
end

-- TODO: check fnameescape or shellescape?
function M.escape_path(arg)
    return vim.fn.shellescape(arg, true)
end

function M.wrap_sed_replace(pattern, replacement, flags)
    return string.format("s/%s/%s/%s", pattern, replacement or "", flags or "")
end

-- TODO: check that this is okay for paths and ordinary strings
function M.format_prettydiff_arg(name, value)
    return string.format('%s:"%s"', name, value)
end

-- Returns a list of currently available formatters for the specified filetype.
function M.get_available_formatters_for_ft(ft)
    local available_formatters = {}
    local user_defined_formatters = config.values.filetype

    for formatter_filetype, formatter_functions in pairs(user_defined_formatters) do
        if ft == "*" or ft == formatter_filetype then
            for _, formatter_function in ipairs(formatter_functions) do
                local formatter_info = formatter_function()
                table.insert(available_formatters, formatter_info)
            end
        end
    end

    return available_formatters
end

-- NOTE: to contributors
-- NOTE: use these for "lua/formatter/filetypes"

function M.withl(f, ...)
    local argsl = { ... }
    return function(...)
        local argsr = { ... }
        return f(unpack(argsl), unpack(argsr))
    end
end

function M.withr(f, ...)
    local argsr = { ... }
    return function(...)
        local argsl = { ... }
        return f(unpack(argsl), unpack(argsr))
    end
end

function M.copyf(f)
    return function(...)
        return f(...)
    end
end

-----------------------------------------------------------------------------
-- Tables

function M.is_empty(s)
    if type(s) == "table" then
        for _, v in pairs(s) do
            if not M.is_empty(v) then
                return false
            end
        end
        return true
    end
    return s == nil or s == ""
end

function M.split(s, sep, plain)
    if s ~= "" then
        local t = {}
        for c in vim.gsplit(s, sep, plain) do
            t[c] = true
        end
        return t
    end
end

function M.is_same(a, b)
    if type(a) ~= type(b) then
        return false
    end
    if type(a) == "table" then
        if #a ~= #b then
            return false
        end
        for k, v in pairs(a) do
            if not M.is_same(b[k], v) then
                return false
            end
        end
        return true
    else
        return a == b
    end
end

-----------------------------------------------------------------------------
-- Vim

function M.set_lines(bufnr, startLine, endLine, lines)
    return vim.api.nvim_buf_set_lines(bufnr, startLine, endLine, false, lines)
end

function M.get_lines(bufnr, startLine, endLine)
    return vim.api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
end

function M.fire_event(event, silent)
    local cmd = string.format(
        "%s doautocmd <nomodeline> User %s",
        silent and "silent" or "",
        event
    )
    vim.api.nvim_command(cmd)
end

function M.get_buffer_variable(buf, var)
    local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
    if status then
        return result
    end
    return nil
end

--- get a table that maps a window to a view
---@see vim.fn.winsaveview()
function M.get_views_for_this_buffer()
    local windows_containing_this_buffer = vim.fn.win_findbuf(vim.fn.bufnr())
    local window_to_view = {}
    for _, w in ipairs(windows_containing_this_buffer) do
        vim.api.nvim_win_call(w, function()
            window_to_view[w] = vim.fn.winsaveview()
        end)
    end
    return window_to_view
end

--- restore view for each window
---@param window_to_view table maps window to a view
---@see vim.fn.winrestview()
function M.restore_view_per_window(window_to_view)
    for w, view in pairs(window_to_view) do
        if vim.api.nvim_win_is_valid(w) then
            vim.api.nvim_win_call(w, function() vim.fn.winrestview(view) end)
        end
    end
end

return M
