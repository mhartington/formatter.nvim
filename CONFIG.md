# Sample configuration

Below is a non-extensive list of tools you can use with Formatter.nvim. Since the plugin does not define formatters to run, you must specify them in your neovim config.

## Prettier

Prettier can be configured for multiple filetypes, but the below config will use JavaScript as the example.

```lua
require('formatter').setup({
  filetype = {
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
          stdin = true
        }
      end
    },
  }
})
```

## Rustfmt

```lua
require('formatter').setup({
  filetype = {
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
  }
})
```

## shfmt

```lua
require('formatter').setup({
  filetype = {
    sh = {
        -- Shell Script Formatter
       function()
         return {
           exe = "shfmt",
           args = { "-i", 2 },
           stdin = true,
         }
       end,
   }
  }
})
```

## luafmt

```lua
require('formatter').setup({
  filetype = {
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
  }
})
```

## stylua

```lua
require('formatter').setup({
  filetype = {
     lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "--config-path "
              .. os.getenv("XDG_CONFIG_HOME")
              .. "/stylua/stylua.toml",
            "-",
          },
          stdin = true,
        }
      end,
    },
  }
})
```

## clang-format

```lua
require('formatter').setup({
  filetype = {
    cpp = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
          }
        end
    },
  }
})
```

## rubocop

```lua
require('formatter').setup({
  filetype = {
    ruby = {
       -- rubocop
       function()
         return {
           exe = "rubocop", -- might prepend `bundle exec `
           args = { '--auto-correct', '--stdin', '%:p', '2>/dev/null', '|', "awk 'f; /^====================$/{f=1}'"},
           stdin = true,
         }
       end
     }
  }
})
```

## terraform

```lua
require('formatter').setup({
  filetype = {
    terraform = {
      function()
        return {
          exe = "terraform",
          args = { "fmt", "-" },
          stdin = true
        }
      end
    }
  }
})
```

## Black

```lua
require('formatter').setup({
  filetype = {
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = "black", -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end
    }
  }
})
```

## autopep8

```lua
require("formatter").setup({
  filetype = {
    python = {
      function()
        return {
          exe = "python3 -m autopep8",
          args = {
            "--in-place --aggressive --aggressive",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = false
        }
      end
    }
  }
})
```

## bibclean

```lua
require('formatter').setup({
  filetype = {
    bib = {
      function()
        return {
          exe = "bibclean", -- this should be available on your $PATH
          args = {"-align-equals"},
          stdin = true
        }
      end
    }
  }
})
```
