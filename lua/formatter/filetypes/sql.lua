local M = {}

function M.pgformat()
  return {
    exe = "pg_format --inplace -",
    stdin = true,
  }
end

function M.sqlfluff_postgres()
  return {
    exe = "sqlfluff",
    args = {
      "fix",
      "--disable-progress-bar",
      "-f",
      "-n",
      "-",
      "--dialect",
      "postgres",
    },
    stdin = true,
  }
end

return M
