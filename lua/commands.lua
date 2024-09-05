-- Define commands
local cmd = vim.api.nvim_create_user_command

cmd('Bclose',
  function(opts)
    local bang = opts.bang and "!" or ""
    vim.fn['utils#Bclose'](bang, opts.args)
  end,
  {bang = true, complete = 'buffer', nargs = '?', desc = "Close Buffer"}
)

cmd('Mylib',
  function(opts)
    vim.fn['mylib#run'](unpack(opts.fargs))
  end,
  {
    nargs = '+',
    complete = 'customlist,mylib#Complete',
    desc = "Mylib commands",
  }
)

cmd('Perldoc',
  function(opts)
    vim.fn['perldoc#Perldoc'](string.format('%q', opts.args))
  end,
  {
    nargs = '*',
    complete='customlist,perldoc#PerldocComplete',
    desc = "Perl documents",
  }
)

cmd('Redir',
  function(opts) vim.fn['utils#CaptureCommandOutput'](opts.args) end,
  {
    complete = 'command',
    nargs = 1,
    desc = "Capture output from a command to register @m"
  }
)

cmd('Rdoc',
  function(opts)
    vim.fn['rdoc#Rdoc'](string.format('%q', opts.args))
  end,
  {
    nargs = '*',
    complete = 'customlist,rdoc#RLisObjs',
    desc = "R documents",
  }
)

cmd('SR',
  function(opts)
    require('util').execute_async(
      string.format("sr %s &>/dev/null &", opts.args),
      {
        on_stdout = function() end,
        on_exit = function()
          vim.notify(
            "Opened in external browser",
            vim.log.levels.INFO,
            {title = "SurfRaw"}
          )
        end,
      }
    )
  end,
  {
    nargs = '*',
    desc = "Search with surfraw"
  }
)

cmd("StataHelp",
  function(opts)
    local args = opts.fargs
    if args[1] == 'pdf' then
      table.remove(args, 1)
      vim.fn['utils#StataGenHelpDocs'](args:concat(" "), "pdf")
    else
      vim.fn['utils#StataGenHelpDocs'](opts.args)
    end
  end,
  { nargs = '*', desc = "Stata Help" }
)

cmd('ToggleZenMode', 'call utils#ToggleZenMode()', {desc = "Toggle Zen Mode"})

