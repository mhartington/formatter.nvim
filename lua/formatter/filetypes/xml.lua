local M = {}

function M.tidy()
  return {
    exe = "tidy",
    args = {
      "-quiet",
      "-xml",
      "--indent auto",
      "--indent-spaces 2",
      "--vertical-space yes",
      "--tidy-mark no",
    },
    stdin = true,
    try_node_exe = true,
  }
end

function M.xmllint()
  return {
    exe = "xmllint",
    args = { "--format", "-" },
    stdin = true,
  }
end

return M
