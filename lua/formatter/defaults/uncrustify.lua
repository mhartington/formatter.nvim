return function(lang)
  return {
    exe = "uncrustify",
    args = { "-q", "-l " .. lang },
    stdin = true,
  }
end
