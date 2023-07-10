function _G.extract_hl_group_link(buf, row, col)
    local info = vim.inspect_pos(buf, row, col)
    local syntax = info.syntax
    local treesitter = info.treesitter
    local hl_group_links = {}

    for _, v in ipairs(syntax) do
        table.insert(hl_group_links, v.hl_group_link)
    end

    for _, v in ipairs(treesitter) do
        local hl = string.gsub(v.hl_group_link, "^@", "")
        table.insert(hl_group_links, hl)
    end

    return hl_group_links
end

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<A-space>', [[<C-\><C-n>]],        opts)
  vim.keymap.set('t', ';j',        [[<C-\><C-n>]],        opts)
  -- vim.keymap.set('t', '<C-h>',     [[<Cmd>wincmd h<CR>]], opts)
  -- vim.keymap.set('t', '<C-j>',     [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set('t', '<C-k>',     [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set('t', '<C-l>',     [[<Cmd>wincmd l<CR>]], opts)
  -- vim.keymap.set('t', '<C-w>',     [[<C-\><C-n><C-w>]],   opts)
end

function _G.BufIsBig(bufnr)
    bufnr = bufnr or 0
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end
