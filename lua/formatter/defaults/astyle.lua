return function(mode)
  return {
    exe = "astyle",
    args = { "--mode=" .. mode },
    stdin = true,
  }
end
