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
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = false,
      only_render_image_at_cursor = true,
      filetypes = { "markdown", "vimwiki", "rmd" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
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
  local buffer = img.buffer
  img:clear()
  if vim.bo[buffer].filetype == 'kittypreviewimage' then
      vim.api.nvim_buf_delete(buffer, { unload = true })
  end
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

local open_window_for_preview = function(method)
  if not method or method == "infile" then
    return vim.api.nvim_get_current_win()
  end

  win_clear_images()
  local cache_file = vim.fn.stdpath "cache" .. "kitty_image_preview"
  vim.fn["utils#Preview_data"](cache_file, "kitty_image_preview_buf", method, "n", "kittypreview")

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false
  vim.bo.filetype = "kittypreviewimage"
  vim.cmd.resize(12)
  local win_id = vim.api.nvim_get_current_win()

  return win_id
end

local gen_id_with = function(file)
  if not file then return end
  file = vim.fn.fnamemodify(file, ":p")
  if
    vim.fn.filereadable(file) == 0
    or not (file:match "%.png$" or file:match "%.jpe?g$")
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

  local display_row = line - (window.scroll_y > 3 and 2 or 1) - window.scroll_y
  if display_row < 1 then display_row = 1 end
  local preview_image = require("image").from_file(file, {
    id = image_id or gen_id_with(file),
    window = window_id,
    buffer = buffer_id,
    with_virtual_padding = true,
    inline = true,
    x = 0,
    y = display_row,
  })
  return preview_image
end

-- Define Global Command
local display_image = function(file, opts)
  file = vim.fn.fnamemodify(file, ":p")
  local image_id = gen_id_with(file)
  if not image_id then return end

  local opts_default = { method = "infile", update = false }
  opts = vim.tbl_extend("keep", opts or {}, opts_default)

  local oriwin_ind = vim.api.nvim_get_current_win()
  local curor_pos = vim.api.nvim_win_get_cursor(0)

  local preview_image = image_is_rendered(image_id)
  if preview_image then
    if not opts.update then return end
    preview_image:clear()
  end

  open_window_for_preview(opts.method)
  preview_image = generate_image(file, image_id, opts.line)
  if not preview_image then return end
  preview_image:render()
  vim.schedule(function()
    local window_width = vim.api.nvim_win_get_width(0)
    local image_width = preview_image.rendered_geometry.width
    local display_col = math.ceil((window_width - image_width) / 2)
    preview_image:move(display_col, preview_image.geometry.y)
  end)

  vim.fn.win_gotoid(oriwin_ind)
  local win_images = vim.w.win_images or {}
  table.insert(win_images, preview_image.id)
  vim.w.win_images = win_images
  vim.api.nvim_win_set_cursor(0, curor_pos)
end

vim.api.nvim_create_user_command("PreviewImage", function(args)
  local args_number = #args.fargs
  local file = args.fargs[args_number]
  local method = "infile"
  if args_number > 1 then
    method = args.fargs[1]
  end
  display_image(file, { method = method, update = args.bang })
end, { bang = true, nargs = "+", desc = "Preview image" })

vim.api.nvim_create_user_command("ImageClear", function(args)
  local file = args.fargs[1] or nil
  if file then
    clear_single_image(vim.fn.sha256(vim.fn.fnamemodify(file, ":p")))
  else
    win_clear_images()
  end
end, { nargs = "?", desc = "Clear image preview" })

vim.api.nvim_create_user_command("ImageToggle", function(args)
  local args_number = #args.fargs
  local file = args_number > 0 and args.fargs[1] or nil
  local method = args.bang and "infile" or "split"
  if not file then return end
  local preview_image = image_is_rendered(vim.fn.sha256(file))
  if preview_image then
    image_clear(preview_image)
    return
  end
  display_image(file, { method = method })
end, { bang = true, nargs = "?", desc = "Toggle image preview" })
