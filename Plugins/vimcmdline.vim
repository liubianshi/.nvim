" vimcmdline mappings
let cmdline_map_start          = '<LocalLeader>s'
let cmdline_map_send_and_stay  = '<LocalLeader>se'
let cmdline_map_quit           = '<LocalLeader>rq'
let cmdline_map_send           = '<LocalLeader>l'
let cmdline_map_send_motion    = '<localleader><localleader>'
let cmdline_map_source_fun     = '<LocalLeader>fe'
let cmdline_map_send_paragraph = '<LocalLeader>pe'
let cmdline_map_send_block     = '<LocalLeader>be'

" vimcmdline options
let cmdline_vsplit      = 1      " Split the window vertically
let cmdline_esc_term    = 1      " Remap <Esc> to :stopinsert in Neovim's terminal
let cmdline_in_buffer   = 1      " Start the interpreter in a Neovim's terminal
let cmdline_term_height = 15     " Initial height of interpreter window or pane
let cmdline_term_width  = 90    " Initial width of interpreter window or pane
let cmdline_tmp_dir     = '/tmp' " Temporary directory to save files
let cmdline_outhl       = 1      " Syntax highlight the output
let cmdline_auto_scroll = 1      " Keep the cursor at the end of terminal (nvim)
let cmdline_app           = {}
let cmdline_app['ruby']   = 'pry'
let cmdline_app['sh']     = 'sh'
let cmdline_app['python'] = 'bpython'
let cmdline_app['perl']   = 'perl'
if has('mac')
    let cmdline_app['stata']  = 'stata-se'
else
    let cmdline_app['stata']  = 'stata-se'
endif

" Color
let cmdline_follow_colorscheme = 1
