local M = {}

local get_word_before = function(s, l)
    l = l or 1
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col < s or s < l then
        return nil
    end
    local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return line_content:sub(col - s + 1, col - s + l)
end

M.probes = {
    {
        "probe_punctuation_after_half_symbol", function()
            local word_pre1 = get_word_before(1,1)
            local word_pre2 = get_word_before(2,1)
            if not (word_pre1 and word_pre1:match("[%p]")) then
                return false
            elseif not word_pre2 or word_pre2:match("[%w%p%s]") then
                return true
            else
                return false
            end
        end
    },
    {
        "prove_temporarily_disabled", function()
            return not vim.b.rime_enabled
        end
    }
}

function M.setup_rime(opts)
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
                cmd = { 'rime_ls' },
                -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),
                filetypes = { '*' },
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
            client.request('workspace/executeCommand',
                { command = "rime-ls.toggle-rime" },
                function(_, result, ctx, _)
                    if ctx.client_id == client.id then
                        vim.g.rime_enabled = result
                    end
                end
            )
        end
        _G.ToggleRime = toggle_rime

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
        end, {desc = "Start Chinese Input Method", noremap = true})

        vim.keymap.set('i', stop, function()
            vim.cmd("stopinsert")
            if vim.g.rime_enabled then
                toggle_rime()
            end
            vim.b.rime_enabled = false
            vim.fn.feedkeys("a", "n")
        end, {desc = "Stop Chinese Input Method", noremap = true, expr = true})

        vim.keymap.set('i', esc, "<cmd>stopinsert<cr>",
            {desc = "Stop insert", noremap = true})
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local rime_shared_data_dir = "/usr/share/rime-data"
    local rime_user_dir = "~/.local/share/rime-ls"
    if vim.fn.has('mac') == 1 then
        rime_shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport"
    end

    lspconfig.rime_ls.setup {
        init_options = {
            enabled                  = vim.g.rime_enabled,
            shared_data_dir          = rime_shared_data_dir,
            user_data_dir            = rime_user_dir,
            log_dir                  = rime_user_dir,
            max_candidates           = 9,
            trigger_characters       = {},
            schema_trigger_character = "&" -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
        },
        on_attach = rime_on_attach,
        capabilities = capabilities,
    }
end


M.probe_all_passed = function()
    local probes = M.get_probes()
    for _,probe in pairs(probes) do
        if probe[2]() then return false end
    end
    return(true)
end

M.get_probes = function()
    return M.probes
end

M.auto_toggle_rime_ls_with_space = function()
    if not vim.b.rime_enabled then return 0 end

    local word_before = get_word_before(1, 1)
    if not word_before then return 0 end
    if word_before == " " then
        return 0
    elseif word_before:match("[%w%p]") then
        vim.cmd("ToggleRime on")
        return 1
    else
        vim.cmd("ToggleRime off")
        return 2
    end
end

M.auto_toggle_rime_ls_with_backspace = function()
    if not vim.b.rime_enabled then return 0 end

    local word_before_1 = get_word_before(1, 1)
    local word_before_2 = get_word_before(2, 1)
    if not word_before_1 or word_before_1 ~= " "  or not word_before_2 or word_before_2 == " " then
        return 0
    end
    local is_ascii_before = word_before_2:match("[%w%p]")
    if is_ascii_before then
        vim.cmd("ToggleRime off")
        return 1
    else
        vim.cmd("ToggleRime on")
        return 2
    end
end

return M
