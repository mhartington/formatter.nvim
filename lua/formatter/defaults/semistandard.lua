return function()
  return {
    exe = "semistandard",
    args = { "--stdin", "--fix" },
    stdin = true,
    try_node_modules = true,
  }
end
