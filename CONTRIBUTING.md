# Contribute

<!-- TODO: general contribution guide -->

## Default configurations

All default configurations are placed in the
[default configurations per formatter](lua/formatter/defaults),
[default configurations per `filetype`](lua/formatter/filetypes), and
[default configurations for any `filetype`](lua/formatter/filetypes/any.lua).
You should use the [`util` module](lua/formatter/util)
which has various functions that help with creating default configurations.

The [default configurations per formatter](lua/formatter/defaults) return
functions which create a formatter configuration. For example, the `prettier`
default configuration function takes in a parser argument:

```lua
local util = require "formatter.util"

return function(parser)
  if not parser then
    return {
      exe = "prettier",
      args = {
        "--stdin-filepath",
        util.escape_path(util.get_current_buffer_file_path()),
      },
      stdin = true,
      try_node_modules = true,
    }
  end

  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      util.escape_path(util.get_current_buffer_file_path()),
      "--parser",
      parser,
    },
    stdin = true,
    try_node_modules = true,
  }
end
```

[Default configurations per formatter](lua/formatter/defaults)
are used to create
[default configurations per `filetype`](lua/formatter/filetypes), and
[default configurations for any `filetype`](lua/formatter/filetypes/any.lua).

For example, the
[default formatter configuration for `prettier` for the `typescript` `filetype`](lua/formatter/defaults/typescript.lua) uses the
[default formatter configuration function for `prettier`](lua/formatter/defaults/prettier.lua):

```lua

local M = {}

local defaults = require "formatter.defaults"
local util = require "formatter.util"

-- other formatters...

-- "util.withl" here returns a function that executes the defaults.prettier
-- function with "typescript" as the first argument for the parser
M.prettier = util.withl(defaults.prettier, "typescript")

-- other formatters...

return M
```

The
[default configurations for any `filetype`](lua/formatter/filetypes/any.lua)
are in exactly the same format as
[default configurations per `filetype`](lua/formatter/filetypes).
It is just important to note that this file is special because all formatter
default configurations that can be applied to any `filetype` go here.
