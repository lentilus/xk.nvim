local M = {}

M.xk = function(...)
	local cmd = table.concat({ ... }, " ")
	return vim.fn.systemlist("xk " .. cmd .. " 2>/dev/null")
end

M.xk_async = function(...)
	vim.system({ "xk", ... })
end

M.open_zettel = function(zettel)
	if zettel == nil or zettel == "" then
		return
	end
	local path = M.xk("path", "-z", zettel)[1]
	print(path)
	vim.cmd.edit(path .. "/zettel.tex")
end

M.show_in_split = function(lines)
	-- Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true) -- false means not listed, true means scratch

	-- Set the content of the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Save the current window to switch back to it later
	local current_win = vim.api.nvim_get_current_win()

	-- Open a new horizontal split and set the buffer in the split
	vim.cmd("belowright split")
	vim.cmd("resize 10") -- Set the split height (adjust as needed)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_set_current_win(current_win)
end

return M
