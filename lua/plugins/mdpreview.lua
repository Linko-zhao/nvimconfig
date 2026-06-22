-- return {
-- 	{
-- 		'MeanderingProgrammer/render-markdown.nvim',
-- 		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
-- 		---@module 'render-markdown'
-- 		---@type render.md.UserConfig
-- 		opts = {},
-- 	}
-- }
return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
		opts = {
		},
}
