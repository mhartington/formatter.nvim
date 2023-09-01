local M = {}

function M.styler()
  return {
    exe = "Rscript",
    args = { "-e", '"styler::style_text(readLines(file(\\"stdin\\")))"' },
    stdin = true,
  }
end

return M
