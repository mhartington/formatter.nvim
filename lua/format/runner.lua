local vim = vim

local runner = {
  createJob = function(cmd, args, data)
    return vim.fn.systemlist(string.format("%s %s", cmd, args), lines)
  end
}

return runner
