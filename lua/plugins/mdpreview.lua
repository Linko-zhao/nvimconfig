-- return {
-- 	{
-- 		'MeanderingProgrammer/render-markdown.nvim',
-- 		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
-- 		---@module 'render-markdown'
-- 		---@type render.md.UserConfig
-- 		opts = {},
-- 	}
-- }
-- return {
--     "OXY2DEV/markview.nvim",
--     lazy = false,
--
--     -- Completion for `blink.cmp`
--     -- dependencies = { "saghen/blink.cmp" },
-- 		opts = {
-- 		},
-- }

return {
	"selimacerbas/mdkite.nvim",
  dependencies = { "selimacerbas/kitehost.nvim" },
  config = function()
    require("mdkite").setup({
      -- all optional; sane defaults shown
      instance_mode = "takeover",  -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                    -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "light",      -- "dark" or "light"; initial preview theme
			mermaid_renderer = "rust",
			yaml_mode = "panel",
      debounce_ms = 300,
			scroll_sync = false,
    })
  end,
}
