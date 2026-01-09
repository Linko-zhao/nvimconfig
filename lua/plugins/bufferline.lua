return {
	{
		'akinsho/bufferline.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
      options = {
        -- 使用模式：buffers (显示所有打开的文件)
        mode = "buffers",
				themable = true,
        -- 右侧是否显示关闭按钮
        show_buffer_close_icons = true,
        show_close_icon = false,
        -- 自动根据文件类型对齐 (如 nvim-tree)
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center", -- 居中对齐文字
            separator = true,
          }
        },
        -- 集成 LSP 诊断信息
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        -- 鼠标滚轮切换 buffer
        right_mouse_command = "vertical sbuffer %d", -- 右键拆分显示
        middle_mouse_command = "bdelete! %d",         -- 中键关闭
      },
    },
		keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer Pick" },
      { "<leader>be", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Extension" },
      { "<leader>bd", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by Directory" },
    },
	}
}
