-- rust format on current file
vim.keymap.set('n', '<leader>rf', ':RustFmt<CR>', { desc = 'RustFmt' })

-- make build on current file
vim.keymap.set('n', '<leader>rb', ':make! build<CR>:copen<CR>', { desc = 'Cargo Build' })
vim.keymap.set('n', '<leader>rbo', ':make! build ', { desc = 'Cargo Build with options' })

require('nvim-treesitter.configs').setup {
    highlight = { enable = false },
}
