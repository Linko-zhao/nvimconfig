return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate", -- 安装或更新插件时，自动运行 :TSUpdate
    event = { "BufRead", "BufNewFile" }, -- 懒加载：打开文件时才加载
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "c", "cpp", "python", "go", "gomod", "gowork" },
    },
    config = function ()
      require("nvim-treesitter").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
          if lang and vim.treesitter.query.get(lang, "highlights") then
            vim.treesitter.start(bufnr, lang)
          end
        end,
      })
    end,
  },
}
