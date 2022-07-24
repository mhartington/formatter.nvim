return function()
  return {
    exe = "mix",
    args = {
      "format",
      "-",
    },
    stdin = true,
  }
end
