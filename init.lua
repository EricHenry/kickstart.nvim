--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know how the Neovim basics, you can skip this step)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not sure exactly what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or neovim features used in kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your nvim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

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
vim.opt.clipboard = 'unnamedplus'

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

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
vim.opt.updatetime = 250
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

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Suspend
vim.keymap.set('n', '<C-f>', ':sus<CR>', { desc = 'Suspend', silent = true })

-- Last Buffer
vim.keymap.set('n', 'ga', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>d', ':copen<CR>', { desc = 'Open [Q]uickfix list' })

-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')


-- open up config file
vim.keymap.set( 'n', '<leader>co',
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
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
-- 	desc = 'Highlight when yanking (copying) text',
-- 	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
-- 	callback = function()
-- 		vim.highlight.on_yank()
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd('BufReadPost', {
-- 	pattern = '*',
-- 	callback = function(ev)
-- 		if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
-- 			-- except for in git commit messages
-- 			-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
-- 			if not vim.fn.expand('%:p'):find('.git', 1, true) then
-- 				vim.cmd 'exe "normal! g\'\\""'
-- 			end
-- 		end
-- 	end,
-- })


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

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
autocmd('LspAttach', {
    group = ehGroup,
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        local fzf = require("fzf-lua")
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gr', fzf.lsp_references, '[G]oto [R]eferences')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('gy', vim.lsp.buf.type_definition, 'Type [D]efinition')
        map('<leader>ds', fzf.lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', fzf.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>r', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>a', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>f', function()
            vim.lsp.buf.format { async = true }
            -- require('conform').format()
        end, 'Format Code')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- None of this semantics tokens business.
        -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
        if client and client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
        end
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
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to force a plugin to be loaded.
    --
    --  This is equivalent to:
    --    require('Comment').setup({})

    -- "gc" to comment visual regions/lines
    -- {
    -- 	'numToStr/Comment.nvim',
    -- 	opts = {
    -- 		-- toggler = {
    -- 		-- 	line = '<C-c>',
    -- 		-- 	block = '<A-c>',
    -- 		-- },
    -- 		-- opleader = {
    -- 		-- 	line = '<C-c>',
    -- 		-- 	block = '<A-c>',
    -- 		-- },
    -- 	},
    -- },
    -- NOTE: Plugins can also be configured to run lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    --
    -- which loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `config` key, the configuration only runs
    -- after the plugin has been loaded:
    --  config = function() ... end
    -- better %
    {
        'andymass/vim-matchup',
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
    },
    {
        'kevinhwang91/nvim-bqf',
        config = function()
            require("bqf").setup({
                preview = {
                    auto_preview = false
                }
            });
        end
    },

    { 'lewis6991/gitsigns.nvim', opts = {} },
    { 'mg979/vim-visual-multi', branch = 'master' },
    { 'preservim/tagbar' },
    { 
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            -- require('mini.ai').setup()
            require('mini.comment').setup()
            require('mini.pairs').setup()
            require('mini.surround').setup()
            -- require('mini.jump2d').setup()
            -- require('mini.completion').setup()
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        config = function()
            require("oil").setup({
                columns = {
                    "permissions",
                    "size",
                    "mtime",
                },
                buf_options = {
                    buflisted = false,
                    bufhidden = "hide",
                },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
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
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
                }),
            }

            vim.diagnostic.config {
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = 'minimal',
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                },
            }
        end,
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },
    {                       -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup({
                preset = 'helix',
                icons = { mappings = false, rules = false }
            })

            -- Document existing key chains
            require('which-key').add {
                { '<leader>c', { group = '[C]ode' } },
                { '<leader>d', { group = '[D]ocument' } },
                { '<leader>r', { group = '[R]ename' } },
                { '<leader>s', { group = '[S]earch' } },
                { '<leader>w', { group = '[W]orkspace' } },
            }
        end,
    },
    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>.', function()
                local utils = require 'telescope.utils'
                builtin.find_files { cwd = utils.buffer_dir() }
            end, { desc = 'Find Files (root dir)' })

            -- Shortcut for searching your neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                fzf.files(function() return { cwd = vim.fn.stdpath 'config' } end)
            end, { desc = '[S]earch [N]eovim files' })
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
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                config = function()
                    -- When in diff mode, we want to use the default
                    -- vim text objects c & C instead of the treesitter ones.
                    local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
                    local configs = require 'nvim-treesitter.configs'
                    for name, fn in pairs(move) do
                        if name:find 'goto' == 1 then
                            move[name] = function(q, ...)
                                if vim.wo.diff then
                                    local config = configs.get_module(
                                            'textobjects.move')
                                        [name] ---@type table<string,string>
                                    for key, query in pairs(config or {}) do
                                        if q == query and key:find '[%]%[][cC]' then
                                            vim.cmd('normal! ' .. key)
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
                    'diff',
                    'fish',
                    'html',
                    'json',
                    'lua',
                    'markdown',
                    'markdown_inline',
                    'odin',
                    'ron',
                    'rust',
                    'toml',
                    'vim',
                    'vimdoc',
                    'yaml',
                    'zig',
                },
                -- Autoinstall languages that are not installed
                auto_install = true,
                -- with gruvbox theme set this to false
                highlight = { enable = false },
                -- highlight = { enable = true },
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
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
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

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
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
    -- auto-cd to root of git project
    -- {
    --     'notjedi/nvim-rooter.lua',
    --     config = function()
    --         require('nvim-rooter').setup()
    --     end,
    -- },
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
    -- {
    --     'projekt0n/github-nvim-theme',
    --     name = 'github-theme',
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         -- require('github-theme').setup({ 
    --         --     -- palettes = palettes 
    --         --     palettes = {
    --         --         -- Custom duskfox with black background
    --         --         github_dark = {
    --         --             bg1 = '#000000', -- Black background
    --         --             bg0 = '#1d1d2b', -- Alt backgrounds (floats, statusline, ...)
    --         --             bg3 = '#121820', -- 55% darkened from stock
    --         --             sel0 = '#131b24', -- 55% darkened from stock
    --         --         },
    --         --     },
    --         -- })
    --
    --         require('github-theme').setup({
    --             palettes = { },
    --             specs = {
    --                 github_dark = {
    --                     bg1 = '#24292e', -- Black background
    --                 },
    --             },
    --         })
    --
    --         vim.cmd('colorscheme github_dark')
    --         -- vim.cmd('colorscheme github_dark_default')
    --     end,
    -- },
    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000,
    --     config = function()
    --         -- require("gruvbox").setup({ contrast = "hard" })
    --         --
    --         -- vim.o.background = "dark" -- or "light" for light mode
    --         -- vim.cmd([[colorscheme gruvbox]])
    --         --
    --         -- -- Make comments more prominent -- they are important.
    --         -- local orange = vim.api.nvim_get_hl(0, { name = 'GruvboxOrange' })
    --         -- vim.api.nvim_set_hl(0, 'Comment', orange)
    --         --
    --         -- local white = vim.api.nvim_get_hl(0, { name = 'GruvboxFg1' })
    --         -- vim.api.nvim_set_hl(0, 'Delimiter', white)
    --         -- vim.api.nvim_set_hl(0, 'Operator', white)
    --         -- vim.api.nvim_set_hl(0, 'MatchParens', white)
    --         -- vim.api.nvim_set_hl(0, '@constructor.lua', white)
    --     end
    -- },
    -- {
    --     "junegunn/seoul256.vim",
    --     config = function()
    --         -- " seoul256 (dark):
    --         -- "   Range:   233 (darkest) ~ 239 (lightest)
    --         -- "   Default: 237
    --         vim.g.seoul256_background = 234
    --
    --         -- " seoul256 (light):
    --         -- "   Range:   252 (darkest) ~ 256 (lightest)
    --         -- "   Default: 253
    --         vim.g.seoul256_light_background = 252
    --
    --         -- vim.o.background = 'dark'
    --         vim.g.seoul256_srgb = 1
    --         -- vim.cmd([[colorscheme seoul256-light]])
    --         -- vim.cmd([[colorscheme seoul256]])
    --     end
    -- },
    -- {
    --     "amitds1997/remote-nvim.nvim",
    --     version = "*",                       -- Pin to GitHub releases
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",         -- For standard functions
    --         "MunifTanjim/nui.nvim",          -- To build the plugin UI
    --         "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    --     },
    --     config = true,
    -- }
    -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- put them in the right spots if you want.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
    --
    --  Here are some example plugins that I've included in the kickstart repository.
    -- Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- require 'kickstart.plugins.debug',
    -- require 'kickstart.plugins.indent_line',

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    -- { import = 'custom.plugins' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim.o.termguicolors = true
