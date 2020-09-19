local vim = vim

local runner = {}

function runner.createJob(cmd, args, lines)
  return vim.fn.systemlist(string.format("%s %s", cmd, args), lines)
end
return runner
