# formatter.nvim

**WIP**

A format runner for neovim, written in lua.

## Install

Using your package manager of choice

```vim
" vim-plug
Plug 'mhartington/formatter.nvim'

" dein.nvim
call dein#add('mhartington/formatter.nvim')


" configure the plugin

lua require('formatter').setup(...)
" Provided by setup function
nnoremap <silent> <leader>f :Format<CR>
```

## Configure

By default there are no tools configured. This may change.

To config a tool, you can create a table for the filetype and tool you want to use

```lua
require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
    },
    cpp = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
          }
        end
    }
  }
})
```

Each format tool config is a function that returns a table.
Since each entry is a function, the tables for each file type act as an ordered list (or array).
This mean things will run in the order you list them, keep this in mind.

Each formatter should return a table that consist of:
- `exe`: the program you wish to run
- `args`: a table of args to pass
- `stdin`: If it should use stdin or not.
- `cwd` : The path to run the program from.
- `tempfile_dir`:  directory for temp file when not using stdin (optional)
- `tempfile_prefix`:  prefix for temp file when not using stdin (optional)
- `tempfile_postfix`:  postfix for temp file when not using stdin (optional)

### cwd

The cwd argument can be used for e.g. monolithic projects which contain sources with different styles.
Setting cwd to the path of the file being formatted will cause e.g. `clang-format` to search for the
nearest `.clang-format` file in the file's parent directories.

### Format on save

To enable format on save, you can create a `autocmd` to trigger the formater using `FormatWrite`, which will format and write to the current saved file.

```lua
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua FormatWrite
augroup END
]], true)
```
