# Formatter.nvim

A format runner for `Neovim`.

We want to thank the [`neoformat`](https://github.com/sbdchd/neoformat)
contributors for developing a lot of formatter configurations that we used as
a reference to create our own opt-in default formatter configurations.

## Features

- Written in `Lua`
- Asynchronous execution
- Opt-in default formatter configurations

## Install

With [`packer.nvim`](https://github.com/wbthomason/packer.nvim):
```lua
require('packer').use { 'mhartington/formatter.nvim' }
```

With [`paq-nvim`](https://github.com/savq/paq-nvim):
```lua
require("paq") { 'mhartington/formatter.nvim' }
```

With [`vim-plug`](https://github.com/junegunn/vim-plug):
```vim
Plug 'mhartington/formatter.nvim'
```

With [`Vundle.vim`](https://github.com/VundleVim/Vundle.vim):
```vim
Plugin 'mhartington/formatter.nvim'
```

With [`vim-pathogen`](https://github.com/tpope/vim-pathogen):
```shell
cd ~/.vim/bundle && \
git clone https://github.com/mhartington/formatter.nvim
```

With [`dein.vim`](https://github.com/Shougo/dein.vim):
```vim
call dein#add('mhartington/formatter.nvim')
```

## Configure

Setup:

```lua
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format and FormatWrite commands
require('formatter').setup {
  -- All formatter configurations are opt-in
  filetype = {
    lua = {
      -- Pick from defaults:
      require('formatter.filetypes.lua').stylua,

      -- or define your own:
      function()
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    }
  }
}
```

By default, there are no preconfigured formatters, however there are opt-in
[default configurations per `filetype`](lua/formatter/filetypes)
and [default configurations per formatter](lua/formatter/defaults)
as shown in the snippet above. It is hard to predict what everyone wants, but
at the same time we realize that most formatter configurations are the same.
See the discussion in
[#97](https://github.com/mhartington/formatter.nvim/issues/97) for more
information.

You can use the [default configurations per `filetype`](lua/formatter/filetypes)
and [default configurations per formatter](lua/formatter/defaults)
as a starting point for creating your configurations.
Feel free to contribute to this repository by creating or improving default
configurations that everyone can use! The guide for contributing to default
configurations is below.

You can use the [`util` module](lua/formatter/util) which has various
functions that help with creating default configurations as shown above.

<!-- TODO: with lua callbacks -->

Map keys:
```vim
nnoremap <silent> <leader>f :Format<CR>
nnoremap <silent> <leader>F :FormatWrite<CR>
```

Format and write after save asynchronously:
```vim
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
```

### Configuration specification

Each formatter configuration is a function that returns a table. Because
each entry is a function, the tables for each `filetype` act as an ordered list
(or array). This means things run in the order you list them, keep this
in mind. You can also return `nil` from these functions to conditionally apply
formatters.

Each formatter configuration should return a table that consist of:

- `exe`: the program you wish to run.
- `args`: a table of arguments to pass (optional)
- `stdin`: if it should use the standard input (optional)
- `cwd` : the path to run the program from (optional)
- `try_node_modules`: tries to run a formatter from locally install npm
  packages (optional) (to be implemented)
- `no_append` : don't append the path of the file to the formatter command
  (optional)
- `ignore_exitcode` : set to true if the program expects non-zero success exit
  code (optional)
- `transform` : pass a function that takes in the formatted text and returns
  the text to be applied to the buffer (optional) (see
  [`ruby` `rubocop`](lua/formatter/filetypes/ruby) default formatter
  configuration as an example)
- `tempfile_dir`: directory for temp file when not using `stdin` (optional)
- `tempfile_prefix`: prefix for temp file when not using `stdin` (optional)
- `tempfile_postfix`: postfix for temp file when not using `stdin` (optional)

#### `cwd`

The `cwd` argument can be used for in example monolithic projects which contain
sources with different styles. Setting `cwd` to the path of the file being
formatted causes, for example, `clang-format` to search for the nearest
`.clang-format` file in the file's parent directories.

#### `try_node_modules`

The `try_node_modules` argument is not yet implemented, but feel free to use
this argument in your configurations. When we add support for it, you get
the `node_modules` package scanning functionality automatically!

#### `no_append`

The `no_append` argument is important for formatters that don't take the path
to the formatted file as the last argument. A small minority of formatters take
the path to the formatted file as a named argument. For an example, check the
[default `javascript` `prettydiff` configuration](lua/formatter/filetypes/javascript.lua).

## Contribute

<!-- TODO: general contribution guide? -->

### Default configurations

All default configurations are placed in the 
[default configurations directory](lua/formatter/filetypes) and are grouped by
`filetype`. 
You should use the [`util` module](lua/formatter/util)
which has various functions that help with creating default configurations.

For example, the default configuration of the `prettier` formatter for the
`javascript` `filetype` would be placed in
`lua/formatter/filetypes/javascript.lua` as such:

```lua
local M = {}

local util = require("formatter.util")

-- other formatters...

function M.prettier()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

-- other formatters...

return M
```
