local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local xettelkasten_core= require("xettelkasten.utils").xettelkasten_core
local open_zettel = require("xettelkasten.utils").open_zettel

local M = {}

M.insert = function()
   local title=vim.fn.input("Title: ")
   local zettel=vim.fn.systemlist({xettelkasten_core, "insert", "-z", title})[1]
   open_zettel(zettel)
end

M.mv = function()
    local filename=vim.fn.expand("%:p")
    local title=vim.fn.systemlist({xettelkasten_core, "path", "-p", filename})[1]
    if title == nil then
        print("buffer is not a zettel")
        return
    end

    local new_title=vim.fn.input("new Title: ")
    local new_zettel = vim.fn.systemlist({xettelkasten_core, "mv", "-z", title, "-n", new_title})[1]
    print(new_zettel)
    open_zettel(new_zettel)
end

M.grep = function()
    local cwd = vim.fn.getcwd()
    local zettel_dir=vim.fn.systemlist({xettelkasten_core, "path"})[1]
    vim.cmd.cd(zettel_dir)
    require("telescope.builtin").live_grep()
    vim.cmd.cd(cwd)
end

M.find = function(opts)
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
                actions.close(prompt_bufnr)
                open_zettel(selection[1])
            end)
            return true
        end,
    }):find()
end

M.rm = function(opts)
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
                    print("\nremoved " .. selection[1])
                else
                    print("aborted")
                end
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

return M
