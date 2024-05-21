{pkgs,...}:{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		coc.enable = true;
                coc.settings = {
                  languageserver = {
                    nix = {
                      command = "rnix-lsp";
                      filetypes = [
                        "nix"
                      ];
                    };
                  };
                };

		plugins = with pkgs.vimPlugins; [
		  vim-nix
                  lazy-lsp-nvim
                  lsp-zero-nvim
                  nvim-lspconfig
                  autoclose-nvim
                  tabby-nvim
                  nvim-web-devicons
                  nvim-surround
                  nerdtree
		];
                extraConfig = ''
                  inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
                  inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
                  set ts=2
                  set sw=2
                  set number
                  set relativenumber
                '';
                extraLuaConfig = ''
                  local lsp_zero = require('lsp-zero')

                  lsp_zero.on_attach(function(client,bufnr)
                    lsp_zero.default_keymaps({
                      buffer = bufnr,
                      preserve_mappings = false
                    })
                  end) 
                  require('lazy-lsp').setup({})
                  require('autoclose').setup({})
                  require('nvim-surround').setup({})

                  -- Tabs Control
                  vim.api.nvim_set_keymap("n", "ta", ":$tabnew<CR>", { noremap = true })
                  vim.api.nvim_set_keymap("n", "tc", ":tabclose<CR>", { noremap = true })
                  vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
                  vim.api.nvim_set_keymap("n", "tn", ":tabn<CR>", { noremap = true })
                  vim.api.nvim_set_keymap("n", "tp", ":tabp<CR>", { noremap = true })
                  -- move current tab to previous position
                  vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
                  -- move current tab to next position
                  vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })

                  -- Tree Control
                  vim.api.nvim_set_keymap("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true})
                  '';
	};
}
