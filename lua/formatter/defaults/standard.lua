return function()
  return {
    exe = "standard",
    args = { "--stdin", "--fix" },
    stdin = true,
    try_node_modules = true,
  }
end
