return {
	{
		'akinsho/bufferline.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
      options = {
        -- 使用模式：buffers (显示所有打开的文件)
        mode = "buffers",
				sort_by = "insert_at_end",
				separator_style = "thick",
        -- 右侧是否显示关闭按钮
        show_buffer_close_icons = true,
        show_close_icon = false,
        -- 自动根据文件类型对齐 (如 nvim-tree)
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            text_align = "center", -- 居中对齐文字
            separator = true,
          }
        },
        -- 集成 LSP 诊断信息
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
					local icons = {
						error = "",
						warning = "",
						info = "",
						hint = "󰌵",
					}

					return " " .. (icons[level] or "●") .. " " .. count
        end,
				close_command = "bdelete %d",
        right_mouse_command = "vertical sbuffer %d", -- 右键拆分显示
        middle_mouse_command = "bdelete! %d",         -- 中键关闭
      },
			highlights = {
				-- 整个 bufferline 背景
				fill = {
					bg = "#181818",
				},

				-- 未选中的 buffer
				background = {
					fg = "#9d9d9d",
					bg = "#181818",
					bold = false,
					italic = false,
				},

				-- 当前 buffer
				buffer_selected = {
					fg = "#ffffff",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				-- 可见但非当前 buffer，例如 split 中另一窗口
				buffer_visible = {
					fg = "#cccccc",
					bg = "#181818",
					bold = false,
					italic = false,
				},

				-- separator
				separator = {
					fg = "#181818",
					bg = "#181818",
				},

				separator_selected = {
					fg = "#1f1f1f",
					bg = "#1f1f1f",
				},

				separator_visible = {
					fg = "#181818",
					bg = "#181818",
				},

				-- buffer close icon
				close_button = {
					fg = "#777777",
					bg = "#181818",
				},

				close_button_selected = {
					fg = "#cccccc",
					bg = "#1f1f1f",
				},

				close_button_visible = {
					fg = "#999999",
					bg = "#181818",
				},

				-- modified
				modified = {
					fg = "#d7ba7d",
					bg = "#181818",
				},

				modified_selected = {
					fg = "#d7ba7d",
					bg = "#1f1f1f",
				},

				modified_visible = {
					fg = "#d7ba7d",
					bg = "#181818",
				},

				-- duplicate 文件名
				duplicate = {
					fg = "#808080",
					bg = "#181818",
					italic = true,
				},

				duplicate_selected = {
					fg = "#cccccc",
					bg = "#1f1f1f",
					italic = true,
					bold = false,
				},

				duplicate_visible = {
					fg = "#999999",
					bg = "#181818",
					italic = true,
				},

				-- 当前 tab indicator
				indicator_selected = {
					fg = "#007acc",
					bg = "#1f1f1f",
				},

				-- diagnostic
				diagnostic = {
					fg = "#858585",
					bg = "#181818",
				},

				diagnostic_selected = {
					fg = "#cccccc",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				diagnostic_visible = {
					fg = "#999999",
					bg = "#181818",
				},

				error = {
					fg = "#f14c4c",
					bg = "#181818",
				},

				error_selected = {
					fg = "#f14c4c",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				error_visible = {
					fg = "#f14c4c",
					bg = "#181818",
				},

				warning = {
					fg = "#cca700",
					bg = "#181818",
				},

				warning_selected = {
					fg = "#cca700",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				warning_visible = {
					fg = "#cca700",
					bg = "#181818",
				},

				info = {
					fg = "#3794ff",
					bg = "#181818",
				},

				info_selected = {
					fg = "#3794ff",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				info_visible = {
					fg = "#3794ff",
					bg = "#181818",
				},

				hint = {
					fg = "#4ec9b0",
					bg = "#181818",
				},

				hint_selected = {
					fg = "#4ec9b0",
					bg = "#1f1f1f",
					bold = false,
					italic = false,
				},

				hint_visible = {
					fg = "#4ec9b0",
					bg = "#181818",
				},

				-- diagnostics count
				error_diagnostic = {
					fg = "#f14c4c",
					bg = "#181818",
				},

				error_diagnostic_selected = {
					fg = "#f14c4c",
					bg = "#1f1f1f",
					bold = false,
				},

				warning_diagnostic = {
					fg = "#cca700",
					bg = "#181818",
				},

				warning_diagnostic_selected = {
					fg = "#cca700",
					bg = "#1f1f1f",
					bold = false,
				},

				info_diagnostic = {
					fg = "#3794ff",
					bg = "#181818",
				},

				info_diagnostic_selected = {
					fg = "#3794ff",
					bg = "#1f1f1f",
					bold = false,
				},

				hint_diagnostic = {
					fg = "#4ec9b0",
					bg = "#181818",
				},

				hint_diagnostic_selected = {
					fg = "#4ec9b0",
					bg = "#1f1f1f",
					bold = false,
				},
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
