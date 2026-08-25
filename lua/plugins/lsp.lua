-- lua/plugins/lsp.lua

-- 2. 配置 Diagnostic 的行为
local icons = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }

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
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
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
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
		config = function()
      -- Mason v2 默认安装目录：
      -- ~/.local/share/nvim/mason/packages/vue-language-server
      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      local vue_typescript_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      -- 配置 vtsls，使其处理 Vue 文件中的 TypeScript/JavaScript
      vim.lsp.config("vtsls", {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_typescript_plugin,
              },
            },
          },
        },

        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      })

      -- vue_ls 负责 Vue 模板、SFC 结构等 Vue 专属能力
      vim.lsp.config("vue_ls", {})
    end,
  },
}
