function! s:formatter_complete(...)
  return luaeval('require("formatter.complete").complete(_A)', a:000)
endfunction

command! -nargs=? -range=% -bar
      \ -complete=customlist,s:formatter_complete
      \ Format lua require("formatter.format").format(<q-args>, <q-mods>, <line1>, <line2>)

command! -nargs=? -range=% -bar
      \ -complete=customlist,s:formatter_complete
      \ FormatWrite lua require("formatter.format").format(<q-args>, <q-mods>, <line1>, <line2>, {write = true})

command! -nargs=? -range=% -bar
      \ -complete=customlist,s:formatter_complete
      \ FormatSync lua require("formatter.format").format(<q-args>, <q-mods>, <line1>, <line2>, {sync = true})

command! -nargs=? -range=% -bar
      \ -complete=customlist,s:formatter_complete
	  \ FormatWriteSync lua require("formatter.format").format(<q-args>, <q-mods>, <line1>, <line2>, {write = true, sync = true})
