-- Variables
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig    = require('lspconfig')

local servers = { 'tsserver', 'volar', 'cssls', 'html', 'eslint', 'pyright' }

-- Enable extras of nvim-cmp
for _,name in ipairs(servers) do 
	lspconfig[name].setup {
		capabilities = capabilities,
	}
end

-- Snippets setup
local luasnip = require('luasnip')

-- nvim-cmp setting
local cmp 		= require('cmp')

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = {
		['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
		['<C-Space>'] = cmp.mapping.complete(), -- Completion
    ['<CR>'] = cmp.mapping.confirm { -- Confirm
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
		['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}
}
