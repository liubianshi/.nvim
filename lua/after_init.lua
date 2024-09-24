-- Selecting to open a draft file when no file has been passed in
local no_spectial_arg = true
for _, arg in ipairs(vim.v.argv) do
  if arg ~= "nvim" and arg ~= "--embed" then
    no_spectial_arg = false
    break
  end
end

if no_spectial_arg then
  local current_date = os.date("*t")
  local formatted_date = string.format("scratch_%d-%d-%d", current_date.year, current_date.month, current_date.day)
  local scatch_dir = vim.fn.stdpath('cache') .. "/scratch/"
  if not vim.uv.fs_access(scatch_dir, "R") then
    vim.uv.fs_mkdir(scatch_dir, tonumber("0755", 8))
  end
  -- vim.cmd("edit " .. scatch_dir .. formatted_date)
  vim.cmd.Neotree()
end
