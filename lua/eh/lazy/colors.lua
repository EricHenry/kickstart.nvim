return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			vim.cmd("colorscheme kanagawa-dragon")

			local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
			vim.api.nvim_set_hl(0, 'Comment', bools)
			-- Make it clearly visible which argument we're at.
			local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
			vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })

		end,
	},
	{
		'EricHenry/gruber-darker.nvim',
		config = function()
			require('gruber-darker').setup({
				-- OPTIONAL
				-- transparent = true, -- removes the background
				-- underline = false, -- disables underline fonts
				-- bold = false, -- disables bold fonts
			})
			-- vim.cmd.colorscheme('gruber-darker')
		end,
	},
}
