return function()
  return {
    exe = "dart format",
    args = {
      "--output show",
      "--line-length 120",
    },
    stdin = true,
  }
end
