local dict_path = vim.fn.stdpath('config') .. "/dict"
require("cmp_dictionary").setup({
  paths = { dict_path },
  exact_length = 2,
  first_case_insensitive = true,
  document = {
    enable = true,
    command = { "wn", "${label}", "-over" },
  },
})
