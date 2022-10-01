" Capture output from a command to register @m, to paste, press "mp
command! -nargs=1 -complete=command Redir call utils#CaptureCommandOutput(<q-args>)
command! -nargs=* StataHelp call utils#StataGenHelpDocs(<q-args>)
command! -nargs=* StataHelpPDF call utils#StataGenHelpDocs(<q-args>, "pdf")
command! -bang -complete=buffer -nargs=? Bclose call utils#Bclose('<bang>', '<args>')
command! -range=% LbsRF <line1>,<line2>:call utils#RFormat()
command! -nargs=* SR call system(printf("sr %s &>/dev/null &", "<args>"))
command! RUN FloatermNew --name=repl --wintype=normal --position=right

command! -nargs=* -complete=customlist,perldoc#PerldocComplete Perldoc :call perldoc#Perldoc(<q-args>)
command! -nargs=* -nargs=? -complete=customlist,RLisObjs Rdoc :call rdoc#Rdoc(<q-args>)
