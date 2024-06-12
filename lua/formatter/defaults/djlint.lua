return function()
  return {
    exe = "djlint",
    args = {
      "--reformat",
      "-",
    },
    stdin = true,
  }
end
