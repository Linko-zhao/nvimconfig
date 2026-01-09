-- lua/plugins/lsp.lua

local icons = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }

-- 2. 配置 Diagnostic 的行为
vim.diagnostic.config({
  -- 行内虚拟文字 (错误信息显示在行尾)
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN]  = icons.Warn,
      [vim.diagnostic.severity.HINT]  = icons.Hint,
      [vim.diagnostic.severity.INFO]  = icons.Info,
    },
    -- 如果你希望保留原来的高亮组名称（通常不需要手动设，内核会自动处理）
    -- linehl = { ... },
    -- numhl = { ... },
  },
  -- 下划线
  underline = true,
  -- 插入模式下不更新诊断信息（避免打字时报错信息跳动）
  update_in_insert = false,
  -- 排序：错误优先显示
  severity_sort = true,
  -- 悬浮窗配置
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded", -- 圆角边框，适配你的 VSCode 主题
    source = "always",  -- 始终显示报错的来源 (例如 gopls)
    header = "",
    prefix = "",
  },
})

return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "gopls", "lua_ls", "vimls" },
      handlers = {
        -- 这种写法会自动适配 0.11 的新接口，同时利用 lspconfig 的默认配置
        function(server_name)
          -- local capabilities = {} -- 如果将来加补全，这里会用到
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. 这里的配置只处理通用的 UI 和 快捷键
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end,
      })
    end,
  },
}
