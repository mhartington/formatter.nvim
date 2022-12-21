return function()
  return {
    exe = "php-cs-fixer",
    args = {
      "fix",
    },
    stdin = false,
    ignore_exitcode = true,
  }
end
