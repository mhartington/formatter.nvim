return function()
  return {
    exe = "tex-fmt",
    args = {
      "--stdin",
      "--print",
    },
    stdin = true,
  }
end
