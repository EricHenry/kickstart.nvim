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

-- delete the current buffer
vim.keymap.set('n', '<leader>x', ':bd<CR>')

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
    {}
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

-------------------------------------------------------------------------------
-- Plugins                                                                   --
-------------------------------------------------------------------------------

---------------
-- gitsigns
---------------
vim.pack.add("https://github.com/lewis6991/gitsigns.nvim")

---------------
-- Color
---------------
vim.pack.add("https://github.com/vague2k/vague.nvim")
require("vague").setup({ })
vim.cmd("colorscheme vague")

---------------
-- Tagbar
---------------
vim.pack.add("https://github.com/preservim/tagbar")
vim.g.tagbar_ctags_bin = "~/opt/ctags/ctags"

---------------
-- Surround
---------------
vim.pack.add("https://github.com/kylechui/nvim-surround")
require("nvim-surround").setup()

---------------
-- Hop
---------------
vim.pack.add("https://github.com/smoka7/hop.nvim")
local hop = require('hop')
hop.setup {
    keys = 'etovxqpdygfblzhckisuran'
}
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'gw', hop.hint_words, { remap = true })

---------------
-- TMUX Nav
---------------
vim.pack.add("https://github.com/christoomey/vim-tmux-navigator")
vim.keymap.set('', '<c-h>',  '<cmd>TmuxNavigateLeft<cr>' )
vim.keymap.set('', '<c-j>',  '<cmd>TmuxNavigateDown<cr>' )
vim.keymap.set('', '<c-k>',  '<cmd>TmuxNavigateUp<cr>' )
vim.keymap.set('', '<c-l>',  '<cmd>TmuxNavigateRight<cr>' )
vim.keymap.set('', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>' )

---------------
-- Undo tree
---------------
vim.pack.add("https://github.com/mbbill/undotree")
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

---------------
-- FZF Lua
---------------

vim.pack.add("https://github.com/ibhagwan/fzf-lua")
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


---------------
-- Fugitive
---------------
vim.pack.add("https://github.com/tpope/vim-fugitive")
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

