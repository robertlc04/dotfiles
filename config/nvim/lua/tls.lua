-- Basic configs
local builtin = require('telescope.builtin')

require('telescope').setup()

-- Extensions
require'telescope'.load_extension("workspaces")

-- Mapping
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader><leader>', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
vim.keymap.set('n', '<leader>w', '<cmd>Telescope workspaces<cr>', {})
