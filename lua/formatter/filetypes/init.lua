-- NOTE: this script exports mapping of module names in this folder to their contents

-- TODO: extract a function from this for filetypes and defaults?

local M = {}

-- NOTE: https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
local this_script_path = debug.getinfo(1).source:match "@?(.*/)"
local this_script_dir = vim.fn.fnamemodify(this_script_path, ":p:h")
local this_script_dir_script_paths = vim.fn.split(
  vim.fn.glob(this_script_dir .. "/*.lua"),
  "\n"
)

for _, script_path in ipairs(this_script_dir_script_paths) do
  local script_name = vim.fn.fnamemodify(script_path, ":t:r")
  if script_name ~= "init" then
    M[script_name] = require("formatter.filetypes." .. script_name)
  end
end

return M
