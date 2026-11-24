local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function extract_key(line)
    local i = 1

    while i <= #line and line:sub(i, i):match("%s") do
        i = i + 1
    end

    if line:sub(i, i) ~= "@" then
        return nil
    end

    while i <= #line and line:sub(i, i) ~= "{" do
        i = i + 1
    end

    if i > #line then
        return nil
    end

    i = i + 1

    while i <= #line and line:sub(i, i):match("%s") do
        i = i + 1
    end

    local start = i

    while i <= #line and line:sub(i, i) ~= "," do
        i = i + 1
    end

    if i > #line then
        return nil
    end

    return line:sub(start, i - 1)
end

local function pick_citation(keys)
  pickers.new({}, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = keys 
    },
    sorter = conf.generic_sorter({}),

        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()

                actions.close(prompt_bufnr)

                -- Insert citation key at cursor
                vim.api.nvim_put({ selection[1] }, "", true, true)
            end)

            return true
        end,
    }):find()
e
M.put = function()
    local cwd = vim.fn.getcwd()
    local bib = vim.fn.globpath(cwd,"**/*.bib",false,true)
    if #bib == 0 then
        vim.notify("No bib files found")
        return
    end
    local file = io.open(bib,"r")
    local keys = {}
    if not file then
        vim.notify("Failed to open bib file")
        return 
    end
    for line in file:lines() do 
        local key = extract_key(line)
        if key ~= nil then
            table.insert(keys,key)
        end
    end
    pick_citation(keys)
end

nd

return M 
