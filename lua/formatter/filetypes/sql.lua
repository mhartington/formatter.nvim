local M = {}

function M.pgformat()
  return {
    exe = "pg_format --inplace -",
    stdin = true,
  }
end

function M.sql_formatter()
  return {
    exe = "sql-formatter",
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
    ignore_exitcode = false,
  }
end

return M
