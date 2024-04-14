local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local xettelkasten_core= require("xettelkasten.utils").xettelkasten_core
local open_zettel = require("xettelkasten.utils").open_zettel

local M = {}

M.rm = function(opts)
    opts = opts or {}
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == nil then
        print("buffer is not a zettel")
        return
    end

	local references=vim.fn.systemlist({xettelkasten_core, "ref", "ls", "-z", title })

    pickers.new(opts, {
        prompt_title = "Remove Reference",
        finder = finders.new_table {
            results = references
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local selected = selection[1]

                vim.fn.system({xettelkasten_core, "ref", "rm", "-z", title, "-r", selected})
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

M.find = function(opts)
    opts = opts or {}
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == nil then
        print("buffer is not a zettel")
        return
    end

	local references=vim.fn.systemlist({xettelkasten_core, "ref", "ls", "-z", title })

    pickers.new(opts, {
        prompt_title = "References in " .. title,
        finder = finders.new_table {
            results = references
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                open_zettel(selection[0])
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

M.insert = function(opts)
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == nil then
        print("buffer is not a zettel")
        return
    end

    local results= vim.fn.systemlist({xettelkasten_core, "ls"})
    opts = opts or {} pickers.new(opts, {
        prompt_title = "Add Reference",
        finder = finders.new_table {
            results = results
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local selected = selection[1]
                vim.fn.system({xettelkasten_core, "ref", "insert", "-z", title, "-r", selected})
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

return M
