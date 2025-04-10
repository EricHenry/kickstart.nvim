-- rust format on current file
vim.keymap.set('n', '<leader>f', ':RustFmt<CR>', { desc = 'RustFmt' })

-- make build on current file
vim.keymap.set('n', '<leader>mm', ':make! build<CR>', { desc = 'Cargo Build' })
vim.keymap.set('n', '<leader>mc', ':make! build ', { desc = 'Cargo Build with options' })

require('nvim-treesitter.configs').setup {
    highlight = { enable = false },
}
