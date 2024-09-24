local M = {}

function M.crystal()
  return {
    exe = "crystal",
    args = {
      "tool",
      "format",
      "--no-color",
      "-",
    },
    stdin = true,
  }
end

return M
