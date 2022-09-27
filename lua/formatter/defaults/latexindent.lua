return function()
  return {
    exe = "latexindent",
    args = {
      "-g",
      "/dev/null",
    },
    stdin = true,
  }
end
