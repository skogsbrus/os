set nocompatible
set number relativenumber
let mapleader = " "
set hidden
syntax on

" Ignore files
set wildignore+=*.pyc
set wildignore+=*build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/venv/*
set wildignore+=**/.git/*

" Wrap git commit lines
au FileType gitcommit setlocal tw=72

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

" Keep it centered (thanks Prime)
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Highlight traling whitespaces
" highlight ExtraWhitespace ctermbg=red guibg=red
" match ExtraWhitespace /\s\+$/
" au BufWinEnter * match ExtraWhitespace /\s\+$/
" au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" au InsertLeave * match ExtraWhitespace /\s\+$/
" au BufWinLeave * call clearmatches()
" nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Remove all trailing whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Tabs vs spaces
set tabstop=4 " show existing tab with 4 spaces width
set shiftwidth=4 " when indenting with '>', use 4 spaces width
set expandtab " On pressing tab, insert 4 spaces

" Yank everything and force quit
nmap <leader>yq gg0vG$"+y:q!<CR>

set foldmethod=manual

 " Treesitter
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Server names must match in this doc to get default settings
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
    'pyright',
    'solargraph',
    'cmake',
    'terraformls',
    'rnix',
    'clangd',
    'sumneko_lua',
    'yamlls',
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- do this one manually due to custom cmd
nvim_lsp['elixirls'].setup {
  cmd = { "elixir-ls" },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}

require('Comment').setup {
  opleader = {
    line = "gc",
    block = "gb",
  },
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  basic = true,
  extra = true,
}
EOF
