return function()
  return {
    exe = "zig",
    args = { "fmt", "--ast-check", "--stdin" },
    stdin = true,
  }
end
