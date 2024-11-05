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

-- @param params:table
function M.goimports_reviser(params)
  if params == nil or type(params) ~= "table" then
    params = {}
  end
  return {
    exe = "goimports-reviser",
    args = params,
    stdin = true,
  }
end

return M
