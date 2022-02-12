# Configuration

Check the [default configuration](lua/formatter/filetypes) directory for 
provided default configurations.
You can use these as examples of your own configurations or as fully fledged
configurations like this (example for `stylua` formatter):

```lua
local formatter = require "formatter"
local default_lua_configurations = require "formatter.filetypes"

formatter.setup {
  filetype = {
    lua = {
      default_lua_configurations.stylua
    }
  }
}
```
