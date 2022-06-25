return function()
  return {
    exe = "zig",
    args = { "fmt", "--stdin" },
    stdin = true,
  }
end
