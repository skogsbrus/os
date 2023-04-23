{ config
, lib
, pkgs
, unstable
, ...
}:
let
  aw-watcher-vim = pkgs.vimUtils.buildVimPlugin {
    # TODO: contribute to nixpkgs
    name = "aw-watcher-vim";
    src = pkgs.fetchFromGitHub {
      owner = "ActivityWatch";
      repo = "aw-watcher-vim";
      rev = "efdf283f879a89dccd5f4ba71a27f43303577aea";
      sha256 = "CXO7zl63qtwlHCMSa4NVSr5hoxsfc2fwc11a+tWszWU=";
    };
  };
  delaytrain = pkgs.vimUtils.buildVimPlugin {
    # TODO: contribute to nixpkgs
    name = "delaytrain";
    src = pkgs.fetchFromGitHub {
      owner = "ja-ford";
      repo = "delaytrain.nvim";
      rev = "eb8d2157e6a7de1b4f024f7ca5bccc4014d88b05";
      sha256 = "BZ2LSeD1lKyaP6CTSB9PmiGqUe8/p+Z3o56Mv6ZB2qM=";
    };
  };
  cfg = config.skogsbrus.neovim;
  inherit (lib) mkEnableOption;
in
{
  options.skogsbrus.neovim = {
    awWatcher = mkEnableOption "aw-watcher-vim";
  };

  config = {
    programs.neovim = {
      enable = true;
      package = with unstable.legacyPackages.${pkgs.system}; neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        delaytrain
        fzf-vim
        gitsigns-nvim
        nerdtree
        nvim-lspconfig
        nvim-treesitter
        onedark-nvim
        rust-vim
        vim-airline
        vim-elixir
        vim-fugitive
        vim-nix
        vim-obsession
        vim-terraform
        #comment-nvim # crashes on launch with 22.05
        #which-key-nvim # stopped working with 22.05
      ] ++
      (if cfg.awWatcher then [ aw-watcher-vim ] else [ ]);

      extraConfig = ''
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
        nnoremap <leader><leader>f :Files<CR>
        nnoremap <leader><leader>g :GitFiles<CR>
        nnoremap <leader><leader>G :Commits<CR>
        nnoremap <leader><leader>b :Buffers<CR>
        nnoremap <leader><leader>c :Commands<CR>
        nnoremap <leader><leader>r :Rg<CR>

        " Nerdtree
        nnoremap <leader><Tab> :NERDTreeToggle<CR>
        " Exit if NERDTree is the only window remaining in the only tab.
        autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
        " Close the tab if NERDTree is the only window remaining in it.
        autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


        " Git
        nnoremap <leader>gb <cmd>Git blame<CR>
        nnoremap <leader>ga <cmd>Git add -p<CR>
        nnoremap <leader>gdd <cmd>Git diff<CR>
        nnoremap <leader>gdc <cmd>Git diff --cached<CR>
        nnoremap <leader>gs <cmd>Git<CR>
        nnoremap <leader>gr <cmd>Gread<CR>
        nnoremap <leader>gw <cmd>Gwrite<CR>

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

        set timeoutlen=500

        hi diffAdded cterm=bold ctermfg=LightGreen
        hi diffRemoved cterm=bold ctermfg=DarkMagenta

        hi diffFile cterm=NONE ctermfg=DarkBlue
        hi gitcommitDiff cterm=NONE ctermfg=DarkBlue
        hi diffIndexLine cterm=NONE ctermfg=DarkBlue
        hi diffLine cterm=NONE ctermfg=DarkBlue

        lua << EOF
        -- https://github.com/lewis6991/gitsigns.nvim
        require('gitsigns').setup()
        EOF

        lua << EOF
        -- https://github.com/ja-ford/delaytrain.nvim
        require('delaytrain').setup()
        EOF

        lua << EOF
        -- enable color scheme
        require('onedark').setup({
          style = 'deep',
        })
        require('onedark').load()
        EOF

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
          buf_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
          buf_set_keymap('v', '<leader>F', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)

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
            'rust_analyzer'
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

        --require('Comment').setup {
        --  opleader = {
        --    line = "gc",
        --    block = "gb",
        --  },
        --  toggler = {
        --    line = "gcc",
        --    block = "gbc",
        --  },
        --  basic = true,
        --  extra = true,
        --}

        --require("which-key").setup {
        ---- your configuration comes here
        ---- or leave it empty to use the default settings
        ---- refer to the configuration section below
        --}
        EOF
      '';
    };
  };
}
