local M = {}

M.xk = function(...)
	local cmd = table.concat({ ... }, " ")
	return vim.fn.systemlist("xk " .. cmd .. " 2>/dev/null")
end

M.xk_async = function(...)
	vim.system({ "xk", ... })
end

M.open_zettel = function(zettel)
	local path = M.xk("path", "-z", zettel)[1]
	print(path)
	vim.cmd.edit(path .. "/zettel.tex")
end

return M
