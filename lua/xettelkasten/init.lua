local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local xettelkasten_core="/home/lentilus/git/xettelkasten-core/src/xettelkasten"

local M = {}

M.zettel = function(opts)
	local results= vim.fn.systemlist({xettelkasten_core, "ls"})
opts = opts or {} pickers.new(opts, {
        prompt_title = "xettelkasten",
        finder = finders.new_table {
            results = results
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local selected = selection[1]
                print(selected)
                local path=vim.fn.systemlist({xettelkasten_core, "path", "-z", selected})
                -- print(path[1])
                actions.close(prompt_bufnr)
                vim.cmd.edit(path[1] .. "/zettel.tex")
            end)
            return true
        end,
    }):find()
end

M.ref = function(opts)
    opts = opts or {}
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]

    if title == "" then
        return
    end
    print(title)

	local references=vim.fn.systemlist({xettelkasten_core, "ref", "ls", "-z", title })

    pickers.new(opts, {
        prompt_title = title .. " - references",
        finder = finders.new_table {
            results = references
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local selected = selection[1]
                print(selected)
                local path=vim.fn.systemlist({xettelkasten_core, "path", "-z", selected})
                actions.close(prompt_bufnr)
                vim.cmd.edit(path[1] .. "/zettel.tex")
            end)
            return true
        end,
    }):find()
end

return M
