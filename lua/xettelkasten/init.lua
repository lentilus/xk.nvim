local utils = require("xettelkasten.utils")

local function is_zettel()
	if vim.b.iszettel ~= nil then
		return vim.b.iszettel
	end
	local bufnr = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(bufnr)
	local res = utils.xk("path", "-p", path)[1]
	if res ~= nil then
		vim.b.iszettel = true
		vim.b.zettelname = res
	else
		vim.b.iszettel = false
	end
	return vim.b.iszettel
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tex",
	callback = function(_)
		if is_zettel() then
			utils.xk_async("script", "genrefs", "-z", string.format('"%s"', vim.b.zettelname))
			utils.xk_async("script", "genbib")
			utils.xk("script", "gencards", "-z", string.format('"%s"', vim.b.zettelname)) -- why not working async?
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.tex",
	callback = function(_)
		if is_zettel() then
			local fixes = utils.xk("script", "showfixes", "-z", string.format('"%s"', vim.b.zettelname)) -- why not working async?
			if fixes and #fixes > 1 then
				utils.show_in_split(fixes)
				vim.inspect(fixes)
			end
		end
	end,
})
