-- Plugins file './lua/plugins.lua'
require('plugins')

-- Basic Configs
vim.o.ts = 2
vim.o.sw = 2
vim.o.relativenumber = true
vim.g.mapleader = ' '
vim.opt.termguicolors = true


-- Mapping
vim.keymap.set('n','<C-left>','<cmd>bprevious<cr>',{})
vim.keymap.set('n','<C-right>','<cmd>bnext<cr>',{})
vim.keymap.set('n','<C-z>','<cmd>ZenMode<cr>',{} )

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Colorscheme
vim.cmd [[colorscheme everblush]]
vim.g.everblush_transp_bg = 1


-- Mason Config
require('mason').setup({
	ui = {
    icons = {
         package_installed = "✓",
         package_pending = "➜",
         package_uninstalled = "✗"
    }
  }
})
require('mason-lspconfig').setup()


-- Lint Config
require('lint').linters_by_ft = {
	vue = {'eslint', },
	javascript = {'eslint',},
	typescript = {'eslint',}
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = { "lua", "vue", "typescript", "javascript", "python", "css", "html", "scss" },
	sync_install = true,
	auto_install = true,

	highlight = {	enable = true },
	indent = { enable = true	},

})

-- Ale
vim.g.ale_fixers = { 'prettier','eslint' }

-- Charge ALE
vim.api.nvim_exec([[
  let g:ale_lint_on_text_changed = 'never' " desactivar el linting automático
  let g:ale_lint_on_insert_leave = 1 " activar el linting cuando se sale del modo insertar
  let g:ale_lint_on_enter = 0 " desactivar el linting cuando se entra en el buffer
  let g:ale_fix_on_save = 1 " arreglar automáticamente el archivo al guardarlo
]], false)

-- StatusLine
require('lualine').setup()

-- Codium
vim.g.codeium_disable_bindings = 0;
vim.g.codium_no_map_tab = 1

-- Personal Configs

-- Lsp Config
require('lsp')

-- Telescope Config
require('tls')

-- Bufferline Config
require('bufline')

-- Nvim Tree
require('tree')

-- Autocomands

-- Tree Open
vim.api.nvim_create_autocmd({'VimEnter'}, {
	pattern = { "*.*", ".*" },
	command = "NvimTreeOpen"
})

-- Eslint AutoFix
vim.api.nvim_create_autocmd({'BufWrite'}, {
	pattern = { "*.js", "*.ts", "*.vue", "*.css", "*.scss" },
	command = "EslintFixAll"
})
