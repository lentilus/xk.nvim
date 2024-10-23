local utils = require("xettelkasten.utils")
local M = {}

M.publish = function()
	local confirm = vim.fn.input("publish [y/N]: ")
	if confirm ~= "y" then
		print("aborted.")
		return
	end
	local p_response = utils.xk("git", "publish")
	for _, line in pairs(p_response) do
		print(line)
	end
	print("Syncing Anki.")
	utils.xk("script", "syncanki")
end

return M
