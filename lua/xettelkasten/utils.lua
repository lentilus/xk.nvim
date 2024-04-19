local xettelkasten_core = vim.g.xettelkasten_core or "/home/lentilus/git/xettelkasten-core/src/xettelkasten"

local M = {}

M.open_zettel = function(zettel)
    local path=vim.fn.systemlist({xettelkasten_core, "path", "-z", zettel})[1]
    print(path)
    vim.cmd.edit(path .. "/zettel.tex")
end

M.xettelkasten_core = xettelkasten_core

return M
