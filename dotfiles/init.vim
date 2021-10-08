set nocompatible
set number relativenumber
let mapleader = " "

" Tabs
map <leader>t :tab new<CR>

" Windows
nnoremap <C-w>- :split<CR>
nnoremap <C-w><Bar> :vsplit<CR>

" Fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GitFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :Rg<CR>

" Git
nnoremap <leader>gb <cmd>Git blame<cr>
nnoremap <leader>ga <cmd>Git add -p<cr>
nnoremap <leader>gdd <cmd>Git diff<cr>
nnoremap <leader>gdc <cmd>Git diff --cached<cr>
nnoremap <leader>gs <cmd>Git<cr>

" Tabs vs spaces
set tabstop=4 " show existing tab with 4 spaces width
set shiftwidth=4 " when indenting with '>', use 4 spaces width
set expandtab " On pressing tab, insert 4 spaces

" Yank everything and force quit
nmap <leader>yq gg0vG$"+y:q!<CR>

 " Treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

 " LSP clients
:lua require'lspconfig'.pyright.setup{}
:lua require'lspconfig'.elixirls.setup{ cmd = { "/nix/store/xsqkhiz0c1vdrgwm4grvc5jdhvwimyif-elixir-ls-0.7.0/lib/language_server.sh" } }
:lua require'lspconfig'.solargraph.setup{}
:lua require'lspconfig'.cmake.setup{}
:lua require'lspconfig'.clangd.setup{}
