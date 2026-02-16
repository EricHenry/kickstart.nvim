local vim = vim
-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- local function paste()
--     return {
--         vim.fn.split(vim.fn.getreg(""), "\n"),
--         vim.fn.getregtype(""),
--     }
-- end

-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = paste,
--     ["*"] = paste,
--   },
-- }


-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append 'iwhite'

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
-- vim.opt.wildmode = 'list:longest'
vim.opt.wildmode = 'list:longest,full'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- show a column at 80 characters as a guide for long lines
-- vim.opt.colorcolumn = '80'

-- tabs: go big or go home
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.laststatus = 2
vim.o.winborder = 'rounded'

vim.opt.shortmess:append("T")

-- fix netrw copy
-- vim.g.netrw_keepdir = 0

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- delete the current buffer
vim.keymap.set('n', '<leader>x', ':bd<CR>')

-- Suspend
vim.keymap.set('n', '<C-f>', ':sus<CR>', { desc = 'Suspend', silent = true })

-- Last Buffer
vim.keymap.set('n', 'ga', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- make missing : less annoying
vim.keymap.set('n', ';', ':')

-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- greatest remap ever
vim.keymap.set("x", "<leader>r", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', ':copen<CR>', { desc = 'Open [Q]uickfix list' })
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = false,
    float = false,
})


-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')


-- open up config file
vim.keymap.set('n', '<leader>co',
    function()
        local config_dir = vim.fn.stdpath 'config'
        local cmd = string.format(':e %s/init.lua', config_dir)

        vim.cmd(cmd)
    end,
    { desc = '[C]onfig [O]pen' }
)

-------------------------------------------------------------------------------
--
-- autocommands
--
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local ehGroup = augroup("eh", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = yank_group,
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd('BufReadPost', {
    group = ehGroup,
    pattern = '*',
    callback = function(ev)
        if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
            -- except for in git commit messages
            -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
            if not vim.fn.expand('%:p'):find('.git', 1, true) then
                vim.cmd 'exe "normal! g\'\\""'
            end
        end
    end,
})

autocmd('BufEnter', {
    group = ehGroup,
    pattern = "*",
    callback = function()
        -- don't auto add comments on newline enter
        -- https://www.reddit.com/r/neovim/comments/13585hy/trying_to_disable_autocomments_on_new_line_eg/
        vim.opt.formatoptions:remove { "c", "r", "o" }
    end
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)

		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- TODO: find some way to make this only apply to the current line.
		-- if client.server_capabilities.inlayHintProvider then
		--     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		-- end

		-- None of this semantics tokens business.
		-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
		client.server_capabilities.semanticTokensProvider = nil
	end,
})
-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
    {
        'numToStr/Comment.nvim',
        opts = {
            toggler = {
                line = '<C-c>',
                block = '<A-c>',
            },
            opleader = {
                line = '<C-c>',
                block = '<A-c>',
            },
        },
    },
    {
        "wincent/base16-nvim",
        lazy = false,    -- load at start
        priority = 1000, -- load first
        config = function()
            vim.o.background = 'dark'
            vim.cmd([[colorscheme gruvbox-dark-hard]])

            -- XXX: hi Normal ctermbg=NONE
            -- Make comments more prominent -- they are important.
            local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
            vim.api.nvim_set_hl(0, 'Comment', bools)

            -- Make it clearly visible which argument we're at.
            local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
            vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter',
                { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })

            local visual = vim.api.nvim_get_hl(0, { name = "Visual" })
            vim.api.nvim_set_hl(0, '@variable', { fg = visual.fg, })
            vim.api.nvim_set_hl(0, 'Delimiter', { fg = visual.fg, })
            vim.api.nvim_set_hl(0, 'Operator', { fg = visual.fg, })
            vim.api.nvim_set_hl(0, 'MatchParens', { fg = visual.fg, })
        end
    },
    -- {
    --     "vague2k/vague.nvim",
    --     config = function()
    --         require("vague").setup({ transparent = false })
    --         vim.cmd("colorscheme vague")
    --
    --         local status = vim.api.nvim_get_hl(0, { name = "Comment" })
    --         vim.api.nvim_set_hl(0, "LineNr", { fg = status.guifg, bg = status.guibg})
    --         vim.api.nvim_set_hl(0, "SignColumn", { fg = status.fg })
    --         vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#1e1e2e" })
    --     end
    -- },
    -- better %
    {
        'andymass/vim-matchup',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
    },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {},
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master',
    },
    -- {
    --     'preservim/tagbar',
    --     config = function()
    --         vim.g.tagbar_ctags_bin = "~/opt/ctags/ctags"
    --     end
    -- },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        lazy = false,
        config = function()
            require("oil").setup({
                columns = {
                    "permissions",
                    "size",
                    "mtime",
                },
                view_options = {
                    show_hidden = true,
                 },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
    },
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
            keys = 'etovxqpdygfblzhckisuran'
        },
        config = function()
            -- place this in one of your configuration file(s)
            local hop = require('hop')
            hop.setup {}
            local directions = require('hop.hint').HintDirection
            vim.keymap.set('', 'gw', function()
                hop.hint_words()
            end, { remap = true })
        end
    },
    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<c-h>',  '<cmd><C-U>TmuxNavigateLeft<cr>' },
            { '<c-j>',  '<cmd><C-U>TmuxNavigateDown<cr>' },
            { '<c-k>',  '<cmd><C-U>TmuxNavigateUp<cr>' },
            { '<c-l>',  '<cmd><C-U>TmuxNavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        priority = 100,
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require 'cmp'
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm { select = true },
                    ['<C-Space>'] = cmp.mapping.complete(),
                },
                sources = cmp.config.sources( {
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' }, -- For luasnip users.
                        { name = 'path' },
                    }, 
                    {
                        { 
                            name = 'buffer',
                            option = {
                                get_bufnrs = function()
                                    return vim.api.nvim_list_bufs()
                                end
                            }
                        },
                    }),
            }
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
    {
        'stevearc/quicker.nvim',
        -- ft = "qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
        config = function()
            -- collapse the context on startup, annoying to include more
            vim.keymap.set(
                "n",
                "<leader>q",
                function()
                    local quicker = require("quicker")
                    quicker.toggle()
                    quicker.collapse()
                end,
                { desc = "Toggle quickfix", }
            )
            vim.keymap.set(
                "n",
                "<leader>l", 
                function()
                    require("quicker").toggle({ loclist = true })
                end, 
                { desc = "Toggle loclist", }
            )
            require("quicker").setup({
                keys = {
                    {
                        ">",
                        function()
                            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                        end,
                        desc = "Expand quickfix context",
                    },
                    {
                        "<",
                        function()
                            require("quicker").collapse()
                        end,
                        desc = "Collapse quickfix context",
                    },
                },
            })
        end,
    },
    {
        "ibhagwan/fzf-lua",
        opts = {
            -- must be false for the Ashen
            -- integration to work properly!
            fzf_colors = false,
        },
        -- optional for icon support
        config = function()
            -- calling `setup` is optional for customization
            local fzf = require("fzf-lua")
            fzf.setup({
                'max-perf',
                winopts = {
                    split = "belowright new",
                    preview = { hidden = 'hidden' }
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    }
                },
            })

            vim.keymap.set('n', '<leader>sh', function() fzf.helptags() end, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', function() fzf.keymaps() end, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader><leader>', function() fzf.files() end, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sg', function() fzf.git_files() end, { desc = '[S]earch Git [F]iles' })
            vim.keymap.set('n', '<leader>ss', function() fzf.builtin() end, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', function() fzf.grep_cword() end, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>/', function() fzf.live_grep() end, { desc = '[S]earch project by [G]rep' })
            vim.keymap.set('n', '<leader>sd', function() fzf.diagnostics_document() end,
                { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sD', function() fzf.diagnostics_workspace() end,
                { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', function() fzf.resume() end, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>so', function() fzf.oldfiles() end,
                { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader>b', function() fzf.buffers() end, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>.', function()
                -- local utils = require 'telescope.utils'
                -- fzf.find_files { cwd = utils.buffer_dir() }
                fzf.files(function() return { cwd = vim.fn.expand('%:p:h') } end)
            end, { desc = 'Find Files (root dir)' })

            -- Shortcut for searching your neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                fzf.files(function() return { cwd = vim.fn.stdpath 'config' } end)
            end, { desc = '[S]earch [N]eovim files' })

            -- Slightly advanced example of overriding default behavior and theme
            -- vim.keymap.set('n', '<leader>/', function()
            --     -- fzf.live_grep(function() return { cwd = vim.fn.expand('%:p:h') } end)
            --     -- fzf.live_grep(function() return { cwd = vim.fn.expand('%:p:h') } end)
            --     fzf.grep_curbuf()
            --
            --     -- You can pass additional configuration to telescope to change theme, layout, etc.
            --     -- fzf.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
            --     --     -- winblend = 10,
            --     --     previewer = false,
            --     -- })
            -- end, { desc = '[/] Fuzzily search in current buffer' })

            -- Also possible to pass additional configuration options.
            --  See `:help telescope.fzf.live_grep()` for information about particular keys
            -- vim.keymap.set('n', '<leader>s/', function() fzf.grep_curbuf() end, { desc = '[S]earch [/] in Open Files' })
        end
    },
    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

            local Eh_Fugitive = vim.api.nvim_create_augroup('Eh_Fugitive', {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd('BufWinEnter', {
                group = Eh_Fugitive,
                pattern = '*',
                callback = function()
                    if vim.bo.ft ~= 'fugitive' then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = { buffer = bufnr, remap = false }
                    vim.keymap.set('n', '<leader>p', function()
                        vim.cmd.Git 'push'
                    end, { buffer = bufnr, remap = false, desc = '[ ] Git push' })

                    -- rebase always
                    vim.keymap.set('n', '<leader>P', function()
                        vim.cmd.Git { 'pull', '--rebase' }
                    end, { buffer = bufnr, remap = false, desc = '[ ] Git pull --rebase' })

                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set('n', '<leader>t', ':Git push -u origin ',
                        { buffer = bufnr, remap = false, desc = '[ ] :Git push -u origin ' })
                end,
            })

            vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>', { desc = '[ ] Diffget 2' })
            vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>', { desc = '[ ] Diffget 3' })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            -- {
            --     'nvim-treesitter/nvim-treesitter-textobjects',
            --     config = function()
            --         -- When in diff mode, we want to use the default
            --         -- vim text objects c & C instead of the treesitter ones.
            --         local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
            --         local configs = require 'nvim-treesitter.configs'
            --         for name, fn in pairs(move) do
            --             if name:find 'goto' == 1 then
            --                 move[name] = function(q, ...)
            --                     if vim.wo.diff then
            --                         local config = configs.get_module(
            --                                 'textobjects.move')
            --                             [name] ---@type table<string,string>
            --                         for key, query in pairs(config or {}) do
            --                             if q == query and key:find '[%]%[][cC]' then
            --                                 vim.cmd('normal! ' .. key)
            --                                 return
            --                             end
            --                         end
            --                     end
            --                     return fn(q, ...)
            --                 end
            --             end
            --         end
            --     end,
            -- },
        },
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup {
                -- Autoinstall languages that are not installed
                auto_install = true,
                -- with gruvbox theme set this to false
                highlight = { enable = true, },
                -- highlight = { enable = false, },
                indent = { enable = true },
                incremental_selection = {
                    enable = false,
                    keymaps = {
                        init_selection = '<C-space>',
                        node_incremental = '<C-space>',
                        scope_incremental = false,
                        node_decremental = '<bs>',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V',  -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        -- include_surrounding_whitespace = true,
                    },
                    move = {
                        enable = true,
                        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
                    },
                },
            }
        end,
    },
    {
		'neovim/nvim-lspconfig',
		config = function()
			-- Setup language servers.

			-- Rust
			vim.lsp.config('rust_analyzer', {
				-- Server-specific settings. See `:help lspconfig-setup`
				settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
						},
						checkOnSave = {
							enable = true,
						},
						check = {
							command = "clippy",
						},
						imports = {
							group = {
								enable = false,
							},
						},
						completion = {
							postfix = {
								enable = false,
							},
						},
					},
				},
			})
			vim.lsp.enable('rust_analyzer')

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- TODO: find some way to make this only apply to the current line.
					-- if client.server_capabilities.inlayHintProvider then
					--     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					-- end

					-- None of this semantics tokens business.
					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
					client.server_capabilities.semanticTokensProvider = nil

                end,
            })
        end
	},
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            preset = "helix"
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
