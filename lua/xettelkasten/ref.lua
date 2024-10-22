local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local utils = require("xettelkasten.utils")

local M = {}

M.find = function(opts)
	opts = opts or {}
	local filename = vim.fn.expand("%:p")
	local title = utils.xk("path", "-p", string.format('"%s"', filename))[1]

	if title == nil then
		print("buffer is not a zettel")
		return
	end

	local references = utils.xk("ref", "ls", "-z", string.format('"%s"', title))

	pickers
		.new(opts, {
			prompt_title = "References in " .. title,
			finder = finders.new_table({
				results = references,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					utils.open_zettel(selection[1])
				end)
				return true
			end,
		})
		:find()
end

return M
