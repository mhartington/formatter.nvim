local M = {}

local config = require "formatter.config"

M.notify_opts = { title = "Formatter" }

M.current_format_mods = nil

function M.is_current_format_silent()
  return string.match(M.current_format_mods, "silent")
end

function M.trace(txt)
  if
    config.values.logging
    and config.values.log_level <= vim.log.levels.TRACE
    and not M.is_current_format_silent()
  then
    -- NOTE: lsp thinks vim.notify takes one argument
    ---@diagnostic disable-next-line
    vim.notify(txt, vim.log.levels.TRACE, M.notify_opts)
  end
end

function M.debug(txt)
  if
    config.values.logging
    and config.values.log_level <= vim.log.levels.DEBUG
    and not M.is_current_format_silent()
  then
    -- NOTE: lsp thinks vim.notify takes one argument
    ---@diagnostic disable-next-line
    vim.notify(txt, vim.log.levels.DEBUG, M.notify_opts)
  end
end

function M.info(txt)
  if
    config.values.logging
    and config.values.log_level <= vim.log.levels.INFO
    and not M.is_current_format_silent()
  then
    -- NOTE: lsp thinks vim.notify takes one argument
    ---@diagnostic disable-next-line
    vim.notify(txt, vim.log.levels.INFO, M.notify_opts)
  end
end

function M.warn(txt)
  if
    config.values.logging
    and config.values.log_level <= vim.log.levels.WARN
    and not M.is_current_format_silent()
  then
    -- NOTE: lsp thinks vim.notify takes one argument
    ---@diagnostic disable-next-line
    vim.notify(txt, vim.log.levels.WARN, M.notify_opts)
  end
end

function M.error(txt)
  if
    config.values.logging
    and config.values.log_level <= vim.log.levels.ERROR
    and not M.is_current_format_silent()
  then
    -- NOTE: lsp thinks vim.notify takes one argument
    ---@diagnostic disable-next-line
    vim.notify(txt, vim.log.levels.ERROR, M.notify_opts)
  end
end

return M
