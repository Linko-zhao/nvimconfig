return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- 1. 普通模式下的切换 (Toggler)
      toggler = {
        line = "<leader>c<Space>",  -- 把 gcc 改为 <leader>/
        block = "<leader>cs", -- 把 gbc 改为 <leader>bc
      },
      -- 2. 可视模式下的映射 (Opleader)
      opleader = {
        line = "<leader>c<Space>",  -- 把 gc 改为 <leader>/
        block = "<leader>cs",  -- 把 gb 改为 <leader>b
      },
      mappings = {
        extra = false,
      },
    }
  }
}
