function _G.extract_hl_group_link(buf, row, col)
    local info = vim.inspect_pos(buf, row, col)
    local syntax = info.syntax
    local treesitter = info.treesitter
    local hl_group_links = {}

    for k, v in ipairs(syntax) do
        table.insert(hl_group_links, v.hl_group_link)
    end

    for k, v in ipairs(treesitter) do
        local hl = string.gsub(v.hl_group_link, "^@", "")
        table.insert(hl_group_links, hl)
    end

    return hl_group_links 
end
