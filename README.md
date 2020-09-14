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

lua require('format').setup()

nnoremap <silent> <leader>f :Format<CR>
```

## Configure

By default there are no tools configured. This may change.

To config a tool, you can create a table for the filetype and tool you want to use

```lua

require('format').setup({
  javascript = {
      prettier = {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.expand("%:p"), "--single-quote"},
        stdin = true
      }
  },
  lua = {
      luafmt = {
        exe = "luafmt",
        args = {"--indent-count", 2, "--stdin"},
        stdin = true
      }
    }
})
```

Each format tool table must contain the following

- `exe`:  the program you wish to run
- `args`:  a table of args to pass
- `stdin`: If it should use stdin or not. As of now, only stdin tools are supported. But will add support for reading files.

