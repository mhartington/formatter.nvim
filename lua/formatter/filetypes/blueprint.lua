local M = {}

function M.blueprint_compiler()
  return {
    exe = "blueprint-compiler",
    args = {
      "format",
      "-f",
    },
    stdin = false,
  }
end

return M
