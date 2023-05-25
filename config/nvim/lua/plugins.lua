-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  use 'rstacruz/vim-closer'
	
	-- Neovim Tree
	use 'nvim-tree/nvim-tree.lua'

	-- Zen Mode
	use 'folke/zen-mode.nvim'

  -- Lazy loading:
  -- Load on specific commands
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'vue', 'lua', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  -- You can specify rocks in isolation
  use_rocks 'penlight'
  use_rocks {'lua-resty-http', 'lpeg'}

  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && npm install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Post-install/update hook with call of vimscript function with argument
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use specific branch, dependency and run lua file after load
  use {
  	'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  -- You Themes
  use {'dracula/vim', as = 'dracula'}
	use { 'Everblush/nvim', as = 'everblush' }

  -- Mason Packer
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-lint',
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }

	-- Lsp Config
	use {
    "neovim/nvim-lspconfig", -- Main
	 	'hrsh7th/nvim-cmp', -- Autocompletion plugin
   	'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
   	'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
   	'L3MON4D3/LuaSnip', -- Snippets plugin
	}

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.x',
  	requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Workspaces and Sessions
	use {
		'natecraddock/workspaces.nvim',
		'natecraddock/sessions.nvim'
	}

	-- Bufferline
	use {
		'akinsho/bufferline.nvim', 
		tag = "*", 
		requires = 'nvim-tree/nvim-web-devicons'
	}

	-- Multiple Cursors
	use {
		'mg979/vim-visual-multi'
	}

	-- IA AutoComplete
	use {
  'Exafunction/codeium.vim',
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-Enter>', function () return vim.fn['codeium#Accept']() end, { expr = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  end
}
end)
