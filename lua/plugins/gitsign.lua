return {
	{
		"lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				-- 快捷键：预览当前改动的块
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview Hunk" })
				vim.keymap.set("n", "<leader>hi", gs.preview_hunk_inline, { buffer = bufnr, desc = "Preview Hunk" })
				-- 跳转到下一个/上一个改动点
				vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next Hunk" })
				vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev Hunk" })
			end,
		}
	}
}
