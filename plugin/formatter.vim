function! s:formatter_complete(...)
  return luaeval('require("formatter.complete").complete(_A)', a:000)
endfunction

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   Format lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>)

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   FormatWrite lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>, { write = true })

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   FormatLock lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>, { lock = true })

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   FormatWriteLock lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>, { lock = true, write = true })
