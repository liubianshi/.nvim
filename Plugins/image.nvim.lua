local image = require "image"
local backend = "ueberzug"
if vim.env.TERM == "xterm-kitty" or vim.env.WEZTERM_EXECUTABLE ~= "" then
  backend = "kitty"
end

--- @diagnostic disable: missing-fields
image.setup {
  backend = backend,
  integrations = {
    markdown = {
      enabled = false,
      clear_in_insert_mode = false,
      download_remote_images = false,
      only_render_image_at_cursor = true,
      filetypes = { "markdown", "vimwiki", "rmd" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = false,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 120,
  window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
}

local image_is_rendered = function(id)
  if not id then return end
  local rendered_images = require("image").get_images()
  for _, img in pairs(rendered_images) do
    if
      img.id == id
      and img.is_rendered
      and vim.tbl_contains(vim.api.nvim_list_wins(), img.window)
    then
      return img
    end
  end
end

local image_clear = function(img)
  if not img or not img.is_rendered then return end
  local bufid = img.buffer
  local winid = img.window
  local on_popup_window = vim.api.nvim_win_get_config(winid).relative ~= ""
  img:clear()
  vim.schedule(function()
    if vim.bo[bufid].filetype == 'kittypreviewimage' then
      vim.api.nvim_buf_delete(bufid, { unload = true })
    elseif on_popup_window then
      vim.api.nvim_win_close(winid, true)
      -- vim.api.nvim_buf_delete(bufid, { force = true })
    end
  end)
end

local function clear_single_image(id)
  if not id then return end
  local images = require("image").get_images() or {}
  for _, img in ipairs(images) do
    if img.id == id then image_clear(img) end
  end
end

local function win_clear_images()
  local win_id = vim.api.nvim_get_current_win()
  local images = require("image").get_images() or {}
  local win_images = vim.w[win_id].win_images or {}
  for _, img in ipairs(images) do
    if vim.tbl_contains(win_images, img.id) then
      image_clear(img)
    end
  end
end

local open_popup_window = function()
  local popup = require('util.ui').popup({
    relative = "win",
    position = {row = '95%', col = '50%'},
    size = {width = '100%', height = '30%' },
    win_options = {
      winblend = 0
    }
  })
  popup:map("n", "q", function() popup:unmount() end, { noremap = true })
  popup:mount()
  local win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_set_var('popup#highest_zindex_window', win_id)

  return win_id
end


local open_window_for_preview = function(method)
  if not method or method == "popup" then
    return open_popup_window()
  end

  if method == "infile" then
    return vim.api.nvim_get_current_win()
  end

  win_clear_images()
  local cache_file = vim.fn.stdpath("cache") .. "/kitty_image_preview"
  vim.fn["utils#Preview_data"](cache_file, "kitty_image_preview_buf", method, "n", "kittypreview")

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false
  vim.bo.filetype = "kittypreviewimage"

  if method == 'split' then
    vim.cmd.resize(12)
  elseif method == "vsplit" then
    vim.cmd [[vertical resize 70]]
  end

  local win_id = vim.api.nvim_get_current_win()
  return win_id
end

local gen_id_with = function(file)
  if not file then return end
  file = vim.fn.fnamemodify(file, ":p")
  local ext = vim.fn.fnamemodify(file, ":e")
  if
    vim.fn.filereadable(file) == 0
    or not vim.tbl_contains({"png", "jpeg", "jpg", "gif", "webp"}, ext)
  then
    return nil
  end
  return vim.fn.sha256(file)
end

local generate_image = function(file, image_id, linenr)
  local window_id = vim.api.nvim_get_current_win()
  local buffer_id = vim.api.nvim_win_get_buf(window_id)
  local line = linenr or vim.fn["utils#GetNearestEmptyLine"]()
  local window = require("image.utils.window").get_window(window_id)
  if not window then return end

  local display_opts = {
    id = image_id or gen_id_with(file),
    window = window_id,
    buffer = buffer_id,
    with_virtual_padding = false,
    inline = false,
    x = 0
  }
  local display_row = line - (window.scroll_y > 3 and 2 or 1) - window.scroll_y
  if display_row > 1 then display_opts.y = display_row end
  local preview_image = require("image").from_file(file, display_opts)
  return preview_image
end

local centered_image_in_popup_window = function(img)
  if
    not image
    or not img.is_rendered
    or vim.api.nvim_win_get_config(img.window).relative == ""
  then
    return
  end
  local window_width = vim.api.nvim_win_get_width(img.window)
  local image_width = img.rendered_geometry.width
  local display_col = math.ceil((window_width - image_width) / 2)
  img:move(display_col, img.geometry.y)
end

-- Define Global Command
local display_image = function(file, opts)
  file = vim.fn.fnamemodify(file, ":p")
  local image_id = gen_id_with(file)
  if not image_id then return end

  local opts_default = { method = "infile", update = false }
  opts = vim.tbl_extend("keep", opts or {}, opts_default)

  local oriwin_id = vim.api.nvim_get_current_win()
  local curor_pos = vim.api.nvim_win_get_cursor(0)

  local preview_image = image_is_rendered(image_id)
  if preview_image then
    if not opts.update then return end
    preview_image:clear()
  end

  open_window_for_preview(opts.method)
  vim.schedule(function()
    preview_image = generate_image(file, image_id, opts.line)
    if not preview_image then return end
    preview_image:render()
    centered_image_in_popup_window(preview_image)
    vim.fn.win_gotoid(oriwin_id)
    local win_images = vim.w.win_images or {}
    table.insert(win_images, preview_image.id)
    vim.w.win_images = win_images
    vim.api.nvim_win_set_cursor(0, curor_pos)
  end)
end

vim.api.nvim_create_user_command("PreviewImage", function(args)
  local args_number = #args.fargs
  local file = args.fargs[args_number]
  local method = "popup"
  if args_number > 1 then method = args.fargs[1] end
  display_image(file, { method = method, update = args.bang })
end, { bang = true, nargs = "+", desc = "Preview image" })

vim.api.nvim_create_user_command("ImageClear", function(args)
  local file = args.fargs[1] or nil
  local img_id = gen_id_with(file)
  if file and not img_id then return end
  if file then
    clear_single_image(img_id)
  else
    win_clear_images()
  end
end, { nargs = "?", desc = "Clear image preview" })

local image_toggle = function(args)
  args = args or {}
  local args_number = args.fargs and #args.fargs or 0
  local file = args_number > 0 and args.fargs[1] or vim.fn.expand("<cfile>")
  local img_id = gen_id_with(file)
  if not img_id then return end
  local method = args.bang and "infile" or "popup"

  local preview_image = image_is_rendered(img_id)
  if preview_image then
    image_clear(preview_image)
    return
  end
  display_image(file, { method = method })
end

vim.api.nvim_create_user_command(
  "ImageToggle",
  image_toggle,
  { bang = true, nargs = "?", desc = "Toggle image preview" }
)

local augruoup_iamge = vim.api.nvim_create_augroup("LBS_Image_Adjust", {clear = true})
vim.api.nvim_create_autocmd({"WinResized"}, {
  group = augruoup_iamge,
  callback = function()
    local imgs = require('image').get_images()
    for _, img in ipairs(imgs) do
      centered_image_in_popup_window(img)
    end
  end
})

vim.api.nvim_create_autocmd({"FileType"}, {
  group = augruoup_iamge,
  pattern = {"markdown", "rmd", "norg", "org"},
  callback = function(_)
    vim.keymap.set("n", "<cr>", function()
      local file = vim.fn.expand("<cfile>")
      local img_id = gen_id_with(file)
      if not img_id then
        win_clear_images()
      else
        image_toggle({file})
      end
    end, {
      desc = "Display image file under cursor",
      noremap = true,
      silent = true,
      buffer = true,
    })
  end
})

