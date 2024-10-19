local utils = require("xettelkasten.utils")
local M = {}

M.journal = function()
	local zettel = utils.xk("script", "journal")[1]
	utils.open_zettel(zettel)
end

return M
