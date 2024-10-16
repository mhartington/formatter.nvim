local M = {}

function M.terraformfmt()
  return {
    exe = "terraform",
    args = { "fmt", "-" },
    stdin = true,
  }
end

function M.tofufmt()
  return {
    exe = "tofu",
    args = { "fmt", "-" },
    stdin = true,
  }
end

return M
