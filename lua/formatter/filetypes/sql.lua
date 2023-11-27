local M = {}

function M.pgformat()
  return {
    exe = "pg_format --inplace -",
    stdin = true,
  }
end

function M.sqlfluff()
  return {
    exe = "sqlfluff",
    args = {
      "format",
      "--disable-progress-bar",
      "--nocolor",
      "-",
    },
    stdin = true,
    ignore_exitcode = true,
  }
end

return M
