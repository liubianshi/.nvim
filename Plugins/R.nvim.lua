local opts = {
  R_args = { "--quiet", "--no-save" },
  hook = {
    after_config = function()
      -- This function will be called at the FileType event
      -- of files supported by R.nvim. This is an
      -- opportunity to create mappings local to buffers.
      if vim.o.syntax ~= "rbrowser" then
        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
      end
    end,
    after_R_start = function()
      require('r.term').highlight_term()
      require('r.send').cmd(
        'options(nvimcom_libs_info = "' .. vim.g.R_start_libs .. '")'
      )
      require('r.send').cmd('nvimcom_update_libs()')
    end
  },
  hl_term = true,
  Rout_more_colors = true,
  min_editor_width = 72,
  rconsole_width = 78,
  csv_app = "terminal:vd",
  objbr_openlist = true,
  objbr_place = 'console,right',
  objbr_opendf = false,
  -- bracketed_paste = vim.fn.has('mac') and false or true,
  setwd = 'nvim',
  open_pdf = "no",
  open_html = "no",
  pdfviewer = vim.fn.has('mac') == 0 and "zathura" or "open",
  synctex = false,
  listmethods = true,
  start_libs = vim.g.R_start_libs,
  assign = false,
  rmdchunk = 1,
  disable_cmds = {},
}
-- Check if the environment variable "R_AUTO_START" exists.
-- If using fish shell, you could put in your config.fish:
-- alias r "R_AUTO_START=true nvim"
if vim.env.R_AUTO_START == "true" then
  opts.auto_start = 1
  opts.objbr_auto_start = true
end

require("r").setup(opts)

local map_desc = {
    RCustomStart        = { m = "", k = "", c = "Start",    d = "Ask user to enter parameters to start R" },
    RSaveClose          = { m = "", k = "", c = "Start",    d = "Quit R, saving the workspace" },
    RClose              = { m = "", k = "", c = "Start",    d = "Send to R: quit(save = 'no')" },
    RStart              = { m = "", k = "", c = "Start",    d = "Start R with default configuration or reopen terminal window" },
    RAssign             = { m = "", k = "", c = "Edit",     d = "Replace `config.assign_map` with ` <- `" },
    ROpenPDF            = { m = "", k = "", c = "Edit",     d = "Open the PDF generated from the current document" },
    RDputObj            = { m = "", k = "", c = "Edit",     d = "Run dput(<cword>) and show the output in a new tab" },
    RViewDF             = { m = "", k = "", c = "Edit",     d = "View the data.frame or matrix under cursor in a new tab" },
    RViewDFs            = { m = "", k = "", c = "Edit",     d = "View the data.frame or matrix under cursor in a split window" },
    RViewDFv            = { m = "", k = "", c = "Edit",     d = "View the data.frame or matrix under cursor in a vertically split window" },
    RViewDFa            = { m = "", k = "", c = "Edit",     d = "View the head of a data.frame or matrix under cursor in a split window" },
    RShowEx             = { m = "", k = "", c = "Edit",     d = "Extract the Examples section and paste it in a split window" },
    RSeparatePathPaste  = { m = "", k = "", c = "Edit",     d = "Split the path of the file under the cursor and paste it using the paste() prefix function" },
    RSeparatePathHere   = { m = "", k = "", c = "Edit",     d = "Split the path of the file under the cursor and open it using the here() prefix function" },
    RNextRChunk         = { m = "", k = "", c = "Navigate", d = "Go to the next chunk of R code" },
    RGoToTeX            = { m = "", k = "", c = "Navigate", d = "Go the corresponding line in the generated LaTeX document" },
    RDocExSection       = { m = "", k = "", c = "Navigate", d = "Go to Examples section of R documentation" },
    RPreviousRChunk     = { m = "", k = "", c = "Navigate", d = "Go to the previous chunk of R code" },
    RSyncFor            = { m = "", k = "", c = "Navigate", d = "SyncTeX forward (move from Rnoweb to the corresponding line in the PDF)" },
    RInsertLineOutput   = { m = "", k = "", c = "Send",     d = "Ask R to evaluate the line and insert the output" },
    RSendChunkFH        = { m = "", k = "", c = "Send",     d = "Send all chunks of R code from the document's begin up to here" },
    RSendChunk          = { m = "", k = "", c = "Send",     d = "Send the current chunk of code to R" },
    RSendLAndOpenNewOne = { m = "", k = "", c = "Send",     d = "Send the current line and open a new one" },
    RSendLine           = { m = "", k = "", c = "Send",     d = "Send the current line to R" },
    RSendFile           = { m = "", k = "", c = "Send",     d = "Send the whole file to R" },
    RSendAboveLines     = { m = "", k = "", c = "Send",     d = "Send to R all lines above the current one" },
    RSendChain          = { m = "", k = "", c = "Send",     d = "Send to R the above chain of piped commands" },
    RDSendChunk         = { m = "", k = "", c = "Send",     d = "Send to R the current chunk of R code and move down to next chunk" },
    RDSendLine          = { m = "", k = "", c = "Send",     d = "Send to R the current line and move down to next line" },
    RSendMBlock         = { m = "", k = "", c = "Send",     d = "Send to R the lines between two marks" },
    RDSendMBlock        = { m = "", k = "", c = "Send",     d = "Send to R the lines between two marks and move to next line" },
    RSendMotion         = { m = "", k = "", c = "Send",     d = "Send to R the lines in a Vim motion" },
    RSendParagraph      = { m = "", k = "", c = "Send",     d = "Send to R the next consecutive non-empty lines" },
    RDSendParagraph     = { m = "", k = "", c = "Send",     d = "Send to R the next sequence of consecutive non-empty lines" },
    RILeftPart          = { m = "", k = "", c = "Send",     d = "Send to R the part of the line on the left of the cursor" },
    RNLeftPart          = { m = "", k = "", c = "Send",     d = "Send to R the part of the line on the left of the cursor" },
    RIRightPart         = { m = "", k = "", c = "Send",     d = "Send to R the part of the line on the right of the cursor" },
    RNRightPart         = { m = "", k = "", c = "Send",     d = "Send to R the part of the line on the right of the cursor" },
    RDSendSelection     = { m = "", k = "", c = "Send",     d = "Send to R visually selected lines or part of a line" },
    RSendSelection      = { m = "", k = "", c = "Send",     d = "Send visually selected lines of part of a line" },
    RSendCurrentFun     = { m = "", k = "", c = "Send",     d = "Send the current function" },
    RDSendCurrentFun    = { m = "", k = "", c = "Send",     d = "Send the current function and move the cursor to the end of the function definition" },
    RSendAllFun         = { m = "", k = "", c = "Send",     d = "Send all the top level functions in the current buffer" },
    RHelp               = { m = "", k = "", c = "Command",  d = "Ask for R documentation on the object under cursor" },
    RShowRout           = { m = "", k = "", c = "Command",  d = "R CMD BATCH the current document and show the output in a new tab" },
    RSPlot              = { m = "", k = "", c = "Command",  d = "Send to R command to run summary and plot with <cword> as argument" },
    RClearConsole       = { m = "", k = "", c = "Command",  d = "Send to R: <Ctrl-L>" },
    RListSpace          = { m = "", k = "", c = "Command",  d = "Send to R: ls()" },
    RShowArgs           = { m = "", k = "", c = "Command",  d = "Send to R: nvim.args(<cword>)" },
    RObjectNames        = { m = "", k = "", c = "Command",  d = "Send to R: nvim.names(<cword>)" },
    RPlot               = { m = "", k = "", c = "Command",  d = "Send to R: plot(<cword>)" },
    RObjectPr           = { m = "", k = "", c = "Command",  d = "Send to R: print(<cword>)" },
    RClearAll           = { m = "", k = "", c = "Command",  d = "Send to R: rm(list   = ls())" },
    RSetwd              = { m = "", k = "", c = "Command",  d = "Send to R setwd(<directory of current document>)" },
    RObjectStr          = { m = "", k = "", c = "Command",  d = "Send to R: str(<cword>)" },
    RSummary            = { m = "", k = "", c = "Command",  d = "Send to R: summary(<cword>)" },
    RKnitRmCache        = { m = "", k = "", c = "Weave",    d = "Delete files from knitr cache" },
    RMakePDFKb          = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate a beamer presentation" },
    RMakeAll            = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate all formats in the header" },
    RMakeHTML           = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate an HTML document" },
    RMakeODT            = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate an ODT document" },
    RMakePDFK           = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate a PDF document" },
    RMakeWord           = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate a Word document" },
    RMakeRmd            = { m = "", k = "", c = "Weave",    d = "Knit the current document and generate the default document format" },
    RKnit               = { m = "", k = "", c = "Weave",    d = "Knit the document" },
    RBibTeXK            = { m = "", k = "", c = "Weave",    d = "Knit the document, run bibtex and generate the PDF" },
    RQuartoPreview      = { m = "", k = "", c = "Weave",    d = "Send to R: quarto::quarto_preview()" },
    RQuartoStop         = { m = "", k = "", c = "Weave",    d = "Send to R: quarto::quarto_preview_stop()" },
    RQuartoRender       = { m = "", k = "", c = "Weave",    d = "Send to R: quarto::quarto_render()" },
    RSweave             = { m = "", k = "", c = "Weave",    d = "Sweave the current document" },
    RMakePDF            = { m = "", k = "", c = "Weave",    d = "Sweave the current document and generate a PDF document" },
    RBibTeX             = { m = "", k = "", c = "Weave",    d = "Sweave the document and run bibtex" },
    ROBCloseLists = { m = "", k = "", c = "Object_Browser", d = "Close S4 objects, lists and data.frames in the Object Browser" },
    ROBOpenLists =  { m = "", k = "", c = "Object_Browser", d = "Open S4 objects, lists and data.frames in the Object Browser" },
    ROBToggle =     { m = "", k = "", c = "Object_Browser", d = "Toggle the Object Browser" },
}

local add_namespace = function(packages)
  if not packages then return end
  packages = vim.fn.join(packages, ",")

  local r_script = string.format(
    'nvimcom_update_libs(strsplit("%s", ",")[[1]])',
    packages
  )

  require('r.send').cmd(r_script)
end

vim.api.nvim_create_user_command(
    "RAdd",
    function(tbl) add_namespace(tbl.fargs) end,
    { nargs = "+" }
)


require('util').wk_reg({
  l = {
    "<Plug>RSendSelection", "Send to R visually selected lines or part of a line"
  },
}, {buffer = 0, prefix = "<localleader>", mode = "v"})

require('util').wk_reg({
  A = {
    ":exec 'RAdd ' . expand('<cword>')<cr>",
    "Add package for completion"
  },
}, {buffer = 0, prefix = "<localleader>r", mode = "n"})


