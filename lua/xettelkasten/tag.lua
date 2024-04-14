local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local xettelkasten_core= require("xettelkasten.utils").xettelkasten_core

local M = {}

M.rm = function(opts)
    opts = opts or {}
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == nil then
        print("buffer is not a zettel")
        return
    end

	local references=vim.fn.systemlist({xettelkasten_core, "tag", "ls", "-z", title })

    pickers.new(opts, {
        prompt_title = "Remove Tag",
        finder = finders.new_table {
            results = references
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()[1]
                vim.fn.system({xettelkasten_core, "tag", "rm", "-z", title, "-t", selection})
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

M.insert = function()
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == nil then
        print("buffer is not a zettel")
        return
    end

    local tag=vim.fn.input("Tag: ")
    vim.fn.system({xettelkasten_core, "tag", "insert", "-t", tag})
end

return M
