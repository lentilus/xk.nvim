local utils = require("xettelkasten.utils")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.insert = function()
	local title = vim.fn.input("Title: ")
	local zettel = utils.xk("insert", "-z", title)[1]
	utils.open_zettel(zettel)
end

M.grep = function()
	local cwd = vim.fn.getcwd()
	local zettel_dir = utils.xk("path")[1]
	vim.cmd.cd(zettel_dir)
	require("telescope.builtin").live_grep()
	vim.cmd.cd(cwd)
end

M.find = function(opts)
	local results = utils.xk("ls")
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Find Zettel",
			finder = finders.new_table({
				results = results,
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

M.mv = function()
	local filename = vim.fn.expand("%:p")
	local title = utils.xk("path", "-p", filename)[1]
	if title == nil then
		print("buffer is not a zettel")
		return
	end

	local new_title = vim.fn.input("new Title: ")
	local new_zettel = utils.xk("mv", "-z", title, "-n", new_title)[1]
	print(new_zettel)
	utils.open_zettel(new_zettel)
end

M.rm = function()
	local filename = vim.fn.expand("%:p")
	local title = utils.xk("path", "-p", filename)[1]

	local confirm = vim.fn.input("Are you sure you want to remove '" .. title .. "' [y/N]: ")
	if confirm == "y" then
		utils.xk("rm", "-z", title)
		print("\nremoved " .. title)
	else
		print("aborted")
	end
end

return M
