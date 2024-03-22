local M = {}
local filetypes = {
    'norg', 'org',     'markdown', 'md',    'Rmarkdown', 'rmd',   'org',
    'text', 'unknown', 'mail',     'latex', 'tex',
    'r',    'lua',     'perl',     'raku',  'vim',       'stata',
    'uifloat', 'chatgpt-input'
}
local rime_shared_data_dir = "/usr/share/rime-data"
local rime_user_dir = "~/.local/share/rime-ls"
local rime_ls_cmd = {"/sbin/rime_ls"}
if vim.fn.has('mac') == 1 then
    rime_shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport"
    rime_ls_cmd = {vim.env.HOME .. "/.local/bin/rime_ls"}
end

local get_line_before = function(shift)
    shift = shift or 0
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col < shift then return nil end
    local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return line_content:sub(1, col - shift)
end

local get_chars_before_cursor = function(colnums_before, length)
    length = length or 1
    if colnums_before < length then return nil end
    local content_before = get_line_before(colnums_before - length)
    if not content_before then return nil end
    return content_before:sub(-length, -1)
end

local typing_english = function(shift)
    local content_before = get_line_before(shift)
    if not content_before then return nil end
    return content_before:match("%s[%w%p]+$")
end

local in_english_environment = function()
    local info = vim.inspect_pos()
    local englist_env = false
    for _,ts in ipairs(info.treesitter) do
        if ts.capture == "markup.math" or ts.capture == "markup.raw" then
            return true
        elseif ts.capture == "markup.raw.block" then
            englist_env = true
        elseif ts.capture == "comment" then
            englist_env = false
        end
    end
    if englist_env then
        return englist_env
    end
    for _,syn in ipairs(info.syntax) do
        if syn.hl_group_link:match("MathBlock")
        or syn.hl_group_link:match("NoFormatted")
        then
            return true
        end
    end
    return englist_env
end

M.probes = {
    {
        "probe_temporarily_disabled", function()
            return not vim.b.rime_enabled
        end
    },
    {
        "All_Caps", function()
            return get_line_before():match("[A-Z][%w]*%s*$")
        end
    },
    {
        "probe_punctuation_after_half_symbol", function()
            local word_pre1 = get_chars_before_cursor(1,1)
            local word_pre2 = get_chars_before_cursor(2,1)
            if not (word_pre1 and word_pre1:match("[-%p]")) then
                return false
            elseif not word_pre2 or word_pre2 == "" or word_pre2:match("[%w%p%s]") then
                return true
            else
                return false
            end
        end
    },
    {
        "probe_in_MathBlock", function()
            local info = vim.inspect_pos()
            for _,syn in ipairs(info.syntax) do
                if syn.hl_group_link:match("MathBlock")
                then
                    return true
                end
            end
            for _,ts in ipairs(info.treesitter) do
                if ts.capture == "markup.math" then
                    return true
                end
            end
            return false
        end
    },
}

function M.setup(opts)
    opts = opts or {}
    -- global status
    vim.g.rime_enabled = false

    -- add rime-ls to lspconfig as a custom server
    -- see `:h lspconfig-new`
    local lspconfig = require('lspconfig')
    local configs   = require('lspconfig.configs')
    if not configs.rime_ls then
        configs.rime_ls = {
            default_config = {
                name = "rime_ls",
                cmd = rime_ls_cmd,
                -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),
                filetypes = filetypes,
                single_file_support = true,
            },
            settings = {},
            docs = {
                description = [[https://www.github.com/wlh320/rime-ls, A language server for librime]],
            }
        }
    end

    local rime_on_attach = function(client, _)
        local toggle_rime = function()
            client.request(
                'workspace/executeCommand',
                { command = "rime-ls.toggle-rime" },
                function(_, result, ctx, _)
                    if ctx.client_id == client.id then
                        vim.g.rime_enabled = result
                    end
                end
            )
        end

        local error_rime_ls_not_start_yet = function()
            local status_ok,notify = pcall(require, 'notify')
            if status_ok then
                notify("Start rime-ls with command ToggleRimeLS", 'error', {
                    title = "rime-ls framework not start yet",
                })
            else
                vim.fn.echoerr("Start rime-ls with command ToggleRimeLS")
            end
        end

        -- command for start rime-ls
        vim.api.nvim_create_user_command(
            'ToggleRimeLS',
            function()
                if vim.g.input_method_framework == "rime-ls" then
                    vim.g.input_method_framework = nil
                    if vim.g.rime_enabled then
                        toggle_rime()
                    end
                else
                    vim.g.input_method_framework = "rime-ls"
                end
            end,
            { nargs = 0, desc = "Toggle rime-ls input method framework"}
        )

        -- command for toogle 
        vim.api.nvim_create_user_command(
            'ToggleRime',
            function(opt)
                if vim.g.input_method_framework ~= 'rime-ls' then
                    error_rime_ls_not_start_yet()
                    return 0
                end
                local args = opt.args
                if not args or
                   (args == "on" and not vim.g.rime_enabled) or
                   (args == "off" and vim.g.rime_enabled) then
                    toggle_rime()
                elseif args == "start" then
                    vim.g.rime_enabled = false
                    toggle_rime()
                end
            end,
            { nargs = '?', desc = "Toggle Rime"}
        )

        -- command sync
        vim.api.nvim_create_user_command(
            'RimeSync',
            function()
                if vim.g.input_method_framework == 'rime-ls' then
                    vim.lsp.buf.execute_command({
                        command = "rime-ls.sync-user-data"
                    })
                else
                    error_rime_ls_not_start_yet()
                end
            end,
            { nargs = 0}
        )

        -- Close rime_ls when opening a new window
        local rime_group = vim.api.nvim_create_augroup("RimeAutoToggle", {clear = true}) 
        vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
            pattern = "*",
            group = rime_group,
            callback = function()
                if  vim.g.input_method_framework ~= 'rime-ls' then return end
                if (vim.g.rime_enabled and not vim.b.rime_enabled) then
                    vim.cmd([[ToggleRime off]])
                elseif (not vim.g.rime_enabled and vim.b.rime_enabled) then
                    vim.cmd([[ToggleRime on]])
                end
            end,
            desc = "Close rime_ls when opening a new buffer",
        })

        -- load
        if opts.load then
            vim.g.input_method_framework = "rime-ls"
        end

        -- define default_key_map
        local start   = (opts.keys and opts.keys.start)   or ";f"
        local stop    = (opts.keys and opts.keys.stop)    or ";;"
        local esc     = (opts.keys and opts.keys.esc)     or ";j"
        vim.keymap.set('i', start, function()
            vim.cmd("stopinsert")
            if not vim.g.rime_enabled then
                toggle_rime()
            end
            vim.b.rime_enabled = true
            vim.fn.feedkeys("a", "n")
        end, {desc = "Start Chinese Input Method", noremap = true, buffer = true})

        vim.keymap.set('i', stop, function()
            vim.cmd("stopinsert")
            if vim.g.rime_enabled then
                toggle_rime()
            end
            vim.b.rime_enabled = false
            vim.fn.feedkeys("a", "n")
        end, {desc = "Stop Chinese Input Method", noremap = true, expr = true, buffer = true})

        vim.keymap.set('i', esc, "<cmd>stopinsert<cr>",
            {desc = "Stop insert", noremap = true, buffer = true})
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    lspconfig.rime_ls.setup {
        init_options = {
            enabled                  = vim.g.rime_enabled,
            shared_data_dir          = rime_shared_data_dir,
            user_data_dir            = rime_user_dir,
            log_dir                  = rime_user_dir .. "/log",
            max_candidates           = 9,
            trigger_characters       = {},
            schema_trigger_character = "&" -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
        },
        on_attach = rime_on_attach,
        capabilities = capabilities,
    }
end

M.probe_all_passed = function(ignore_probes)
    local probes = M.get_probes()
    for _,probe in pairs(probes) do
        if (not ignore_probes or vim.fn.index(ignore_probes, probe[1]) > 0)
            and probe[2]() then
            return false
        end
    end
    return(true)
end

M.get_probes = function()
    return M.probes
end

M.auto_toggle_rime_ls_with_space = function()
    if not vim.b.rime_enabled then return 0 end

    -- 行首输入空格或输入连续空格时不考虑输入法切换
    local word_before = get_chars_before_cursor(1)
    if not word_before or word_before == " " then return 0 end

    -- 最后一个字符为英文字符，数字或标点符号时，切换为中文输入法
    -- 否则切换为英文输入法
    if word_before:match("[%w%p]") and not in_english_environment() then
        vim.cmd("ToggleRime on")
        return 1
    else
        vim.cmd("ToggleRime off")
        return 2
    end
end

M.auto_toggle_rime_ls_with_backspace = function()
    if not vim.b.rime_enabled then return 0 end
    local english_env = in_english_environment()
    -- 只有在删除空格时才启用输入法切换功能
    local word_before_1 = get_chars_before_cursor(1)
    if not word_before_1 or word_before_1 ~= " " then return 0 end

    -- 删除连续空格或行首空格时不启动输入法切换功能
    local word_before_2 = get_chars_before_cursor(2)
    if not word_before_2 or word_before_2 == " " then return 0 end

    -- 删除的空格前是一个空格分隔的 WORD ，或者处在英文输入环境下时，
    -- 切换成英文输入法
    -- 否则切换成中文输入法
    if typing_english(1) or english_env then
        vim.cmd("ToggleRime off")
        return 1
    else
        vim.cmd("ToggleRime on")
        return 2
    end
end

M.buf_get_rime_ls_client = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- Get all LSP clients that have attached to the current buffer
    local current_buffer_clients = vim.lsp.buf_get_clients(bufnr)
    if #current_buffer_clients > 0 then
        for _, client in ipairs(current_buffer_clients) do
            if client.name == "rime_ls" then
                return client
            end
        end
    end
    return nil
end

M.buf_attach_rime_ls = function(bufnr, launched)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local rime_ls_cilent = M.buf_get_rime_ls_client(bufnr)
    if rime_ls_cilent then
        return rime_ls_cilent
    end

    -- Get all currently active LSP clients
    local active_clients = vim.lsp.get_active_clients()
    if #active_clients > 0 then
        for _, client in ipairs(active_clients) do
            if client.name == 'rime_ls' then
                vim.lsp.buf_attach_client(bufnr, client.id)
                return client
            end
        end
    end
    if not launched then
        require('lspconfig').rime_ls.launch()
        return M.buf_attach_rime_ls(bufnr, true)
    end
end

M.ToggleRime = function(client)
    client = client or M.buf_get_rime_ls_client()
    if not client or client.name ~= "rime_ls" then return end
    client.request(
        'workspace/executeCommand',
        { command = "rime-ls.toggle-rime" },
        function(_, result, ctx, _)
            if ctx.client_id == client.id then
                vim.g.rime_enabled = result
            end
        end
    )
end

return M
