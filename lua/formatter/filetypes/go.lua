local M = {}

function M.gofmt()
  return {
    exe = "gofmt",
    stdin = true,
  }
end

function M.goimports()
  return {
    exe = "goimports",
    stdin = true,
  }
end

function M.gofumpt()
  return {
    exe = "gofumpt",
    stdin = true,
  }
end

function M.gofumports()
  return {
    exe = "gofumports",
    stdin = true,
  }
end

function M.golines()
  return {
    exe = "golines",
    stdin = true,
  }
end

function M.goimports_reviser()
  return {
    exe = "goimports-reviser",
    args = {
      "-rm-unused -set-alias -format",
      '-imports-order "std,company,project,general"',
    },
    stdin = true
  }
end

return M
