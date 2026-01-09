vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.expandtab = false     -- Tab 转为空格
opt.tabstop = 4         -- Tab 显示为 4 列
opt.shiftwidth = 4      -- 自动缩进 4 空格
opt.softtabstop = 4     -- 编辑时 Tab = 4 空格

opt.termguicolors = true -- 开启真彩色支持
opt.number = true        -- 显示行号
opt.cursorline = true   -- 高亮光标所在行
