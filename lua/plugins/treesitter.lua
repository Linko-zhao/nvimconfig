return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate", -- 安装或更新插件时，自动运行 :TSUpdate
    -- event = { "BufRead", "BufNewFile" }, -- 懒加载：打开文件时才加载
    opts = {
      highlights = { enable = true },
      ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "python", "go", "gomod", "gosum", "gowork", "javascript", "typescript", "json" },
    },
    config = function ()
      local treesitter = require("nvim-treesitter")
			treesitter.setup(opts)
			treesitter.install({ "lua", "vim", "vimdoc", "c", "cpp", "python", "go", "gomod", "gosum", "gowork", "javascript", "typescript", "json" })
      vim.api.nvim_create_autocmd("FileType", {
				pattern = {
				 "lua", "vim", "vimdoc", "c", "cpp", "python", "go", "gomod", "gosum", "gowork", "javascript", "typescript", "json"
				},
				callback = function()
					vim.treesitter.start()
				end,
      })
    end,
  },
}
