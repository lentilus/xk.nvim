local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local xettelkasten_core="/home/lentilus/git/xettelkasten-core/src/xettelkasten"

local open_zettel = function(zettel)
    local path=vim.fn.systemlist({xettelkasten_core, "path", "-z", zettel})
    vim.cmd.edit(path[1] .. "/zettel.tex")
end

local M = {}

M.zettel_insert = function()
   local title=vim.fn.input("Title: ")
   local zettel=vim.fn.systemlist({xettelkasten_core, "insert", "-z", title})[1]
   open_zettel(zettel)
end

M.zettel_mv = function()
    print("not implemented...")
end

M.zettel_find = function(opts)
	local results= vim.fn.systemlist({xettelkasten_core, "ls"})
opts = opts or {} pickers.new(opts, {
        prompt_title = "Find Zettel",
        finder = finders.new_table {
            results = results
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

M.zettel_rm = function(opts)
	local results= vim.fn.systemlist({xettelkasten_core, "ls"})
opts = opts or {} pickers.new(opts, {
        prompt_title = "Find Zettel",
        finder = finders.new_table {
            results = results
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                local confirm=vim.fn.input("Are you sure you want to remove '" .. selection[1] .. "' [y/N]: ")
                if confirm == "y" then
                    vim.fn.systemlist({xettelkasten_core, "rm", "-z", selection[1]})
                    print("removed " .. selection[1])
                else
                    print("aborted")
                end
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

M.ref_rm = function(opts)
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

M.ref_find = function(opts)
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

M.ref_insert = function(opts)
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
