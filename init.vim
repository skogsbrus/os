 set nocompatible
 set number relativenumber
 let mapleader = " "
 " Tabs
 map <leader>t :tab new<CR>
 " Fzf
 map <leader>f :Files<CR>
 map <leader>b :Buffers<CR>
 map <leader>r :Rg<CR>
 " Tabs vs spaces
 set tabstop=4 " show existing tab with 4 spaces width
 set shiftwidth=4 " when indenting with '>', use 4 spaces width
 set expandtab " On pressing tab, insert 4 spaces

 " Treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

 " LSP clients
:lua require'lspconfig'.pyright.setup{}
:lua require'lspconfig'.elixirls.setup{ cmd = { "/nix/store/xsqkhiz0c1vdrgwm4grvc5jdhvwimyif-elixir-ls-0.7.0/lib/language_server.sh" } }
:lua require'lspconfig'.solargraph.setup{}
:lua require'lspconfig'.cmake.setup{}
:lua require'lspconfig'.clangd.setup{}
