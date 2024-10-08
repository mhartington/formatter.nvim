local format = require("formatter.format")
local config = require "formatter.config"
local formatters = config.formatters_for_filetype("js")

-- describe("format", function ()
--     
-- end)

describe("start_task", function ()
    function create_buffer_lines()
        vim.api.nvim_buf_set_lines(0, 1, -1, false, {"Test", "================="})
        return vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end

    before_each(function ()
        create_buffer_lines()
    end)

    it("", function ()
        format.start_task(config, 0, 1)
        print(vim.cmd("messages")[0])
    end)
end)
