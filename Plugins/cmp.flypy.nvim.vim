lua << EOF
require("flypy").setup({
      dict_name = "flypy",         -- 选择码表：flypy为小鹤音形，wubi98为98五笔
      comment = true,              -- 在所有文件类型的注释下开启
      filetype = {},  -- 在指定文件类型下开启
      num_filter = true,           -- 数字筛选
      source_code = false,         -- 显示原码
    })
EOF
