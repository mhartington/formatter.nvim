function! s:formatter_complete(...)
  return luaeval('require("formatter.complete").complete(_A)', a:000)
endfunction

command! -nargs=? -range=%
      \ -complete=customlist,s:formatter_complete
      \ Format lua require("formatter.format").format(<q-args>, <line1>, <line2>, false)

command! -nargs=? -range=%
      \ -complete=customlist,s:formatter_complete
      \ FormatWrite lua require("formatter.format").format(<q-args>, <line1>, <line2>, true)

command! -nargs=? -range=%
      \ -complete=customlist,s:formatter_complete
      \ FormatEmbedded lua require("formatter.embedded").format(<q-args>, <line1>, <line2>, false)

command! -nargs=? -range=%
      \ -complete=customlist,s:formatter_complete
      \ FormatEmbeddedWrite lua require("formatter.embedded").format(<q-args>, <line1>, <line2>, true)
