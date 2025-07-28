local vim = vim

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append 'iwhite'

--" Decent wildmenu in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
-- vim.opt.wildmode = 'list:longest'
vim.opt.wildmode = 'list:longest,full'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- show a column at 80 characters as a guide for long lines
vim.opt.colorcolumn = '80'

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.laststatus = 2

-- fix netrw copy
-- vim.g.netrw_keepdir = 0

vim.keymap.set('n', '<C-f>', ':sus<CR>', { desc = 'Suspend', silent = true })
vim.keymap.set('n', 'ga', '<cmd>e #<cr>', { desc = 'Switch to Last Buffer' })
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

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
vim.keymap.set('n', '<leader>do', ':copen<CR>')
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

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
)

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


vim.pack.add({

    { src = "vague2k/vague.nvim" },
    { src = "lewis6991/gitsigns.nvim" },
    { src = "vague2k/vague.nvim" },
    { src = "vague2k/vague.nvim" },
    { src = "vague2k/vague.nvim" },
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
    -- auto-cd to root of git project
    -- {
    --     'notjedi/nvim-rooter.lua',
    --     config = function()
    --         require('nvim-rooter').setup()
    --     end,
    -- },
    -- better %
    -- {
    --     'andymass/vim-matchup',
    --     config = function()
    --         vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    --     end,
    -- },
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

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {},
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master',
    },
    {
        'preservim/tagbar',
        config = function()
            vim.g.tagbar_ctags_bin = "~/opt/ctags/ctags"
        end
    },
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
    -- {
    --     'stevearc/oil.nvim',
    --     opts = {},
    --     lazy = false,
    --     config = function()
    --         require("oil").setup({
    --             columns = {
    --                 "permissions",
    --                 "size",
    --                 "mtime",
    --             },
    --             view_options = {
    --                 show_hidden = true,
    --              },
    --         })
    --         vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    --     end
    -- },
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
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
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
                -- Autoinstall languages that are not installed
                auto_install = true,
                -- with gruvbox theme set this to false
                highlight = { enable = true, },
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
    -- inline function signatures
    -- {
    --     'ray-x/lsp_signature.nvim',
    --     event = 'VeryLazy',
    --     opts = {},
    --     config = function(_, opts)
    --         -- Get signatures (and _only_ signatures) when in argument lists.
    --         require('lsp_signature').setup {
    --             doc_lines = 0,
    --             handler_opts = {
    --                 border = 'none',
    --             },
    --         }
    --     end,
    -- },
    -- {
    --     'neovim/nvim-lspconfig',
    --     dependencies = { -- Automatically install LSPs and related tools to stdpath for neovim
    --         'williamboman/mason.nvim',
    --         'williamboman/mason-lspconfig.nvim',
    --         'WhoIsSethDaniel/mason-tool-installer.nvim',
    --
    --
    --         -- Useful status updates for LSP.
    --         -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --         { 'j-hui/fidget.nvim', opts = {} },
    --     },
    --     config = function()
    --         local cmp = require 'cmp'
    --
    --         -- LSP servers and clients are able to communicate to each other what features they support.
    --         --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --         --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --         --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    --         local capabilities = vim.lsp.protocol.make_client_capabilities()
    --         capabilities = vim.tbl_deep_extend('force', capabilities,
    --             require('cmp_nvim_lsp').default_capabilities())
    --
    --         -- Disable snippet support
    --         capabilities.textDocument.completion.completionItem.snippetSupport = false
    --
    --         -- Enable the following language servers
    --         --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --         --
    --         --  Add any additional override configuration in the following tables. Available keys are:
    --         --  - cmd (table): Override the default command used to start the server
    --         --  - filetypes (table): Override the default list of associated filetypes for the server
    --         --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --         --  - settings (table): Override the default settings passed when initializing the server.
    --         --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    --         local servers = {
    --             -- clangd = {},
    --             -- gopls = {},
    --             -- pyright = {},
    --             -- rust_analyzer = {},
    --             -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --             --
    --             -- Some languages (like typescript) have entire language plugins that can be useful:
    --             --    https://github.com/pmizio/typescript-tools.nvim
    --             --
    --             -- But for many setups, the LSP (`tsserver`) will work just fine
    --             -- tsserver = {},
    --             --
    --             clangd = {
    --                 keys = {
    --                     { '<leader>cR', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
    --                 },
    --                 filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    --                 root_dir = function(fname)
    --                     return require('lspconfig.util').root_pattern(
    --                             'Makefile',
    --                             'configure.ac',
    --                             'configure.in',
    --                             'config.h.in',
    --                             'meson.build',
    --                             'meson_options.txt',
    --                             'build.ninja'
    --                         )(fname) or
    --                         require('lspconfig.util').root_pattern('compile_commands.json',
    --                             'compile_flags.txt')(fname) or
    --                         require('lspconfig.util').find_git_ancestor(
    --                             fname
    --                         )
    --                 end,
    --                 capabilities = {
    --                     offsetEncoding = { 'utf-16' },
    --                 },
    --                 cmd = {
    --                     'clangd',
    --                     '--background-index',
    --                     '--clang-tidy',
    --                     '--header-insertion=iwyu',
    --                     '--completion-style=detailed',
    --                     '--function-arg-placeholders',
    --                     '--fallback-style=llvm',
    --                 },
    --                 init_options = {
    --                     usePlaceholders = true,
    --                     completeUnimported = true,
    --                     clangdFileStatus = true,
    --                 },
    --             },
    --             rust_analyzer = {
    --                 -- Server-specific settings. See `:help lspconfig-setup`
    --                 keys = {
    --                     { 'K', '<cmd>RustHoverActions<cr>', desc = 'Hover Actions (Rust)' },
    --                     -- { '<leader>cR', '<cmd>RustCodeAction<cr>', desc = 'Code Action (Rust)' },
    --                     -- { '<leader>dr', '<cmd>RustDebuggables<cr>', desc = 'Run Debuggables (Rust)' },
    --                 },
    --                 settings = {
    --                     ['rust-analyzer'] = {
    --                         cargo = {
    --                             allFeatures = true,
    --                             loadOutDirsFromCheck = true,
    --                             runBuildScripts = true,
    --                         },
    --                         -- Add clippy lints for Rust.
    --                         checkOnSave = {
    --                             allFeatures = true,
    --                             command = 'clippy',
    --                             extraArgs = { '--no-deps' },
    --                         },
    --                     },
    --                 },
    --             },
    --             taplo = {
    --                 keys = {
    --                     {
    --                         'K',
    --                         function()
    --                             if vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
    --                                 require('crates').show_popup()
    --                             else
    --                                 vim.lsp.buf.hover()
    --                             end
    --                         end,
    --                         desc = 'Show Crate Documentation',
    --                     },
    --                 },
    --             },
    --             marksman = {},
    --             lua_ls = {
    --                 -- cmd = {...},
    --                 -- filetypes { ...},
    --                 -- capabilities = {},
    --                 settings = {
    --                     Lua = {
    --                         runtime = { version = 'LuaJIT' },
    --                         workspace = {
    --                             checkThirdParty = false,
    --                             -- Tells lua_ls where to find all the Lua files that you have loaded
    --                             -- for your neovim configuration.
    --                             library = {
    --                                 '${3rd}/luv/library',
    --                                 unpack(vim.api.nvim_get_runtime_file('', true)),
    --                             },
    --                             -- If lua_ls is really slow on your computer, you can try this instead:
    --                             -- library = { vim.env.VIMRUNTIME },
    --                         },
    --                         completion = {
    --                             callSnippet = 'Replace',
    --                         },
    --                         -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
    --                         -- diagnostics = { disable = { 'missing-fields' } },
    --                     },
    --                 },
    --             },
    --         }
    --
    --         -- for server_name, server in pairs(servers) do
    --         -- 	-- This handles overriding only values explicitly passed
    --         -- 	-- by the server configuration above. Useful when disabling
    --         -- 	-- certain features of an LSP (for example, turning off formatting for tsserver)
    --         -- 	server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    --         -- 	require('lspconfig')[server_name].setup(server)
    --         -- end
    --         -- Ensure the servers and tools above are installed
    --         --  To check the current status of installed tools and/or manually install
    --         --  other tools, you can run
    --         --    :Mason
    --         --
    --         --  You can press `g?` for help in this menu
    --         require('mason').setup()
    --
    --         -- You can add other tools here that you want Mason to install
    --         -- for you, so that they are available from within Neovim.
    --         local ensure_installed = vim.tbl_keys(servers or {})
    --         vim.list_extend(ensure_installed, {
    --             'stylua', -- Used to format lua code
    --         })
    --         require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    --
    --         require('mason-lspconfig').setup {
    --             handlers = {
    --                 function(server_name)
    --                     local server = servers[server_name] or {}
    --                     -- This handles overriding only values explicitly passed
    --                     -- by the server configuration above. Useful when disabling
    --                     -- certain features of an LSP (for example, turning off formatting for tsserver)
    --                     server.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
    --                         server.capabilities or {})
    --                     require('lspconfig')[server_name].setup(server)
    --                 end,
    --             },
    --         }
    --
    --         vim.diagnostic.config {
    --             virtual_text = false,
    --             -- signs = false,
    --             -- underline = false,
    --             -- update_in_insert = true,
    --             float = {
    --                 focusable = true,
    --                 style = 'minimal',
    --                 border = 'rounded',
    --                 source = 'always',
    --                 header = '',
    --                 prefix = '',
    --             },
    --         }
    --     end,
    -- },
    -- Highlight, edit, and navigate code
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

