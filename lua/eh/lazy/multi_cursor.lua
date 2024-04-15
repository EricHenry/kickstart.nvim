return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*",  -- Use the latest tagged version
	opts = {},  -- This causes the plugin setup function to be called
	keys = {
		{"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i"}},
		{"<A-c>", "<Cmd>MultipleCursorsAddDown<CR>"},
		-- {"<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i"}},
		-- {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>"},
		{"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}},
		{"<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}},
		{"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}},
		{"<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = {"n", "x"}},
		{"<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>"},
	},
}
