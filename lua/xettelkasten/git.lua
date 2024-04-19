local xettelkasten_core= require("xettelkasten.utils").xettelkasten_core
local M = {}

M.publish = function()
    local confirm=vim.fn.input("publish [y/N]: ")
    if confirm ~= "y" then
        print("aborted.")
        return
    end
    print("publishing...")

    local response=vim.fn.systemlist({xettelkasten_core, "git", "publish"})

    for _,line in pairs(response) do
        print(line)
    end
end

return M
