local keymap = vim.keymap

-- 查看当前行悬浮报错详情 (类似鼠标悬停效果)
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- 跳转到上一个/下一个报错
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- 将所有报错放入 Quickfix 列表
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix" })

local builtin = require('telescope.builtin')
keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Goto Definition' })
keymap.set('n', 'gi', builtin.lsp_implementations, { desc = 'Goto Implementation' })
keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Goto References' })
keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = 'Document Symbols' })

keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Docs' })
keymap.set('n', '<C-k>', vim.lsp.buf.hover, { desc = 'Signature Help' })

-- 调试快捷键
local dap = require("dap")
keymap.set("n", "<F5>", function() dap.continue() end)
keymap.set("n", "<F10>", function() dap.step_over() end)
keymap.set("n", "<F11>", function() dap.step_into() end)
keymap.set("n", "<F12>", function() dap.step_out() end)
keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end)
keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
keymap.set("n", "<Leader>dr", function() dap.repl.open() end)
keymap.set("n", "<Leader>dl", function() dap.run_last() end)
keymap.set("n", "<Leader>du", function() require("dapui").toggle() end)
