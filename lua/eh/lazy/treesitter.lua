return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = function()
				-- When in diff mode, we want to use the default
				-- vim text objects c & C instead of the treesitter ones.
				local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
				local configs = require("nvim-treesitter.configs")
				for name, fn in pairs(move) do
					if name:find("goto") == 1 then
						move[name] = function(q, ...)
							if vim.wo.diff then
								local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
								for key, query in pairs(config or {}) do
									if q == query and key:find("[%]%[][cC]") then
										vim.cmd("normal! " .. key)
										return
									end
								end
							end
							return fn(q, ...)
						end
					end
				end
			end,
		},
	},
	config = function()
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			ensure_installed = {
				'bash',
				'c',
				'cpp',
				'fish',
				'html',
				'lua',
				'markdown',
				'ron',
				'rust',
				'toml',
				'vim',
				'vimdoc',
				'zig',
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			-- with gruvbox theme set this to false
			-- highlight = { enable = false },
			highlight = { enable = true },
			-- indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<C-space>',
					node_incremental = '<C-space>',
					scope_incremental = false,
					node_decremental = '<bs>',
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
					goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
					goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
					goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
				},
			},
		}

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}
