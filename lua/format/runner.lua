local vim = vim

local M = {}

function M:new(o)
  o = o or {}
  for n, f in pairs(o) do
    self[n] = f
  end
  setmetatable(o, self)
  self.__index = self

  local options = M.options()
  M.jobId =
    vim.fn.jobstart(
    options.job_cmd,
    {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stderr = M.on_stderr,
      on_stdout = M.on_stdout,
      on_exit = M.on_exit
    }
  )

  return o
end

function M.send(data)
  vim.fn.chansend(M.jobId, data)
  vim.fn.chanclose(M.jobId, "stdin")
end

function M.options()
  local options = {}
  options.command = M.cmd
  options.args = M.args
  options.job_cmd = string.format("%s %s", options.command, options.args)
  return options
end

return M

