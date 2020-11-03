function! s:formatter_complete(...)
  return luaeval('vim.tbl_keys(require("format.complete").complete(_A))', a:000)
endfunction

command! -nargs=? -range=% -bang
      \ -complete=customlist,s:formatter_complete
      \ Format lua require"format.formatter".format("<bang>", <q-args>, <line1>, <line2>, false)

command! -nargs=? -range=% -bang
      \ -complete=customlist,s:formatter_complete
      \ FormatWrite lua require"format.formatter".format("<bang>", <q-args>, <line1>, <line2>, true)
