-- Completion
local mini_completion = require('mini.completion')

mini_completion.setup{}

-- Icons
local mini_icons = require('mini.icons')
mini_icons.setup()

-- Pairs
local mini_pairs = require('mini.pairs')
mini_pairs.setup()

-- Colors hipatterns
local mini_hipatterns = require('mini.hipatterns')
mini_hipatterns.setup()

-- Indent Scope

local mini_indentscope = require('mini.indentscope')
mini_indentscope.setup()

-- Surround

local mini_surround = require('mini.surround')
mini_surround.setup({})

-- LSP configuration
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup{
	cargo = {
			features = "all",
	},
}

-- Mapping

vim.keymap.set('n', '<C-n>', ':bNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':blast<CR>', { noremap = true, silent = true })

-- General Configuration
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
