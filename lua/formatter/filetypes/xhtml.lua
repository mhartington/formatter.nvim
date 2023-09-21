local M = {}

function M.tidy()
  return {
    exe = "tidy",
    args = {
      "-quiet",
      "-xhml",
      "--indent auto",
      "--indent-spaces 2",
      "--vertical-space yes",
      "--tidy-mark no",
    },
    stdin = true,
    try_node_exe = true,
  }
end

return M
