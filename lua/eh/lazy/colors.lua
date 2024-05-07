return {
	{
		'ellisonleao/gruvbox.nvim',
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			require("gruvbox").setup({
			  terminal_colors = true, -- add neovim terminal colors
			  undercurl = true,
			  underline = true,
			  bold = true,
			  italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			  },
			  strikethrough = true,
			  invert_selection = false,
			  invert_signs = false,
			  invert_tabline = false,
			  invert_intend_guides = false,
			  inverse = true, -- invert background for search, diffs, statuslines and errors
			  contrast = "", -- can be "hard", "soft" or empty string
			  palette_overrides = {},
			  overrides = {},
			  dim_inactive = false,
			  transparent_mode = true,
			})
			-- vim.cmd("colorscheme gruvbox")

		end,
	  },
  {
    'jacoborus/tender.vim',
    lazy = false, -- load at start
    priority = 1000, -- load first
    config = function()
      vim.cmd 'colorscheme tender'
    end,
  },
  {
    'kvrohit/rasmus.nvim',
    lazy = false, -- load at start
    priority = 1000, -- load first
    config = function()
      -- vim.cmd("colorscheme rasmus")
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false, -- load at start
    priority = 1000, -- load first
    config = function()
      -- vim.cmd("colorscheme kanagawa-dragon")

      -- local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
      -- vim.api.nvim_set_hl(0, 'Comment', bools)

      -- Make it clearly visible which argument we're at.
      -- local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
      -- vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
    end,
  },
  {
    'EricHenry/gruber-darker.nvim',
    config = function()
      -- require('gruber-darker').setup({
      -- OPTIONAL
      -- transparent = true, -- removes the background
      -- underline = false, -- disables underline fonts
      -- bold = false, -- disables bold fonts
      -- })
      -- vim.cmd.colorscheme('gruber-darker')
    end,
  },
}
