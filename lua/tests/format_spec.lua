local format = require("formatter.format")
local config = require "formatter.config"
local log = require("formatter.log")
-- local formatters = config.formatters_for_filetype("js")

-- describe("format", function ()
--     
-- end)
describe("start_task", function ()
    config.values.log_level = 0
    log.current_format_mods = ""
    local configs_to_run = {}


    local function create_buffer_lines()
        vim.api.nvim_buf_set_lines(0, 1, -1, false, {"Test", "================="})
        return vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end

    local function revert()
        configs_to_run = {}
    end

    local function insert_configs(configs)
        table.insert(configs_to_run, { config = configs, name = "js" })
    end

    before_each(function ()
        create_buffer_lines()
    end)

    describe("when file is given by stdin", function ()
        config.stdin = true

        describe("when buffer does not format", function ()
            config.cmd = "echo \"Test =================\""
            it("should return message", function ()
                insert_configs(config)

                format.start_task(configs_to_run, 0, 1)
                local messages = vim.split(vim.fn.execute("messages", "silent"), "\n")
                local message = messages[2]
                print("++++++++++")
                for i, value in ipairs(messages) do
                    print(value)
                end
                print("++++++++++")

                assert.equals("No change necessary with js", message)
                revert()
            end)
        end)

        -- describe("when buffer formats", function ()
            --     it("should return message", function ()
                --         config.name = "js"
                --         config.config = {exe = "echo \"test ======\""}
                --         print('config', #config)
                --         format.start_task(config, 0, 1)
                --         local message = vim.split(vim.fn.execute("messages", "silent"), "\n")[2]
                --         
                --         assert.equals("No change necessary with js", message)
                --     end)
                -- end)
    end)
end)
