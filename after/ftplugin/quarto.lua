vim.b.slime_cell_delimiter = '```'
vim.b['quarto_is_r_mode'] = nil
vim.b['reticulate_running'] = false

-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = false
vim.wo.breakindent = true
-- vim.wo.showbreak = '|'

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- markdown vs. quarto hacks
local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
vim.api.nvim_win_set_hl_ns(0, ns)


vim.cmd [[
  UltiSnipsAddFiletype quarto.r.markdown
]]
vim.api.nvim_set_option_value('formatprg', "text_wrap", { scope = 'local' })

local fexport = function(oformat, ofile)
    local bufnr = vim.api.nvim_get_current_buf()
    local fname = vim.fn.expand('%')
    oformat = oformat or "html"
    if not ofile then
        local outdir = vim.fn.stdpath('cache') .. "/fexport"
        vim.fn.mkdir(outdir, "p")
        local filename = vim.fn.fnamemodify(vim.fn.swapname(bufnr), ":t")
        filename = filename:gsub('%.swp$', "." .. oformat)
        ofile = outdir .. "/" .. vim.fn.fnameescape(filename)
    end

    local cmd = string.format(
        'fexport --from=%s --to="%s" --outfile="%s" "%s"',
        vim.bo.filetype, oformat, ofile, fname
    )
    print(cmd)
    require('util').execute_async(cmd)
    return ofile
end

local fexport_open = function(oformat)
    oformat = oformat or "html"
    local ofile = fexport(oformat)
    local open = "open"
    if vim.fn.has('mac') == 0 then open = "xdg-open" end
    vim.fn.jobstart(open .. ' "' .. ofile .. '"')
end

local format_desc = {
    docx  = 'd',
    rdocxbook = 'D',
    html = 'h',
    htmlbook = 'H',
    pdf = 'p',
    pdfbook = 'P',
    beamer = 'b',
    pptx = 's'
}

for type, key in pairs(format_desc) do
    vim.keymap.set(
        "n",
        '<localleader>x' .. key,
        function() fexport_open(type) end,
        { desc = "Export to " .. type}
    )
end

require('which-key').add {
  { "<localleader>x", group = "Export ..." },
}

vim.keymap.set("i", "<A-=>",
  function() vim.api.nvim_put({"<- "}, "c", at_end_of_line(), true) end,
  { buffer = true, desc = "Assign operator", silent = true }
)
vim.keymap.set( "i", "<A-\\>",
  function() vim.api.nvim_put({"%>%"}, "c", at_end_of_line(), true) end,
  { buffer = true, desc = "Pipe operator", silent = true }
)
vim.keymap.set("n", "<c-x>", function()
  require("util").bibkey_action(vim.fn.expand "<cword>")
end, { desc = "Show action related bibkey" })

vim.keymap.set({"n", "i"}, "<localleader>il", function()
  vim.fn['ref_link#add']()
end, { desc = "Add Link"})

vim.keymap.set({"x", "o"}, "ic", function()
  vim.fn['text_obj#MdCodeBlock']('i')
  end, {desc = "Chunk i", silent = true, buffer = true})

vim.keymap.set({"x", "o"}, "ac", function()
  vim.fn['text_obj#MdCodeBlock']('a')
  end, {desc = "Chunk a", silent = true, buffer = true})
