{ config
, lib
, pkgs
, unstable
, ...
}:
let
  cfg = config.skogsbrus.neovim;
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
  gen = pkgs.vimUtils.buildVimPlugin {
    # TODO: contribute to nixpkgs
    name = "gen";
    src = pkgs.fetchFromGitHub {
      owner = "David-Kunz";
      repo = "gen.nvim";
      rev = "87fbe811155b90eea58622614809705b966009ad";
      sha256 = "Bt7yJxToUnPv3JqBwWQeywIbVRqzHBqnu3NUaIxFx/M=";
    };
  };
  treesitterContextCfg = ''
    lua << EOF
      require("nvim-treesitter.configs").setup({
        ensure_installed = {},
        highlight = { enable = true},
      })
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    EOF
  '';
  inherit (lib) mkEnableOption;
in
{
  options.skogsbrus.neovim = {
    allGrammars = mkEnableOption "Enable all treesitter grammars";
    copilot = mkEnableOption "Enable Copilot";
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
        gen
        gitsigns-nvim
        nerdtree
        plenary-nvim
        nvim-lspconfig
        nvim-treesitter-context
        onedark-nvim
        rust-vim
        telescope-nvim
        vim-airline
        vim-elixir
        vim-fugitive
        vim-nix
        vim-obsession
        vim-terraform
      ]
      ++ (if cfg.allGrammars then [ nvim-treesitter.withAllGrammars ] else [ ])
      ++ (if cfg.copilot then [ copilot-vim ] else [ ]);

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
        nnoremap <leader>gdc <cmd>Git diff --cached<CR>
        nnoremap <leader>gs <cmd>Git<CR>
        nnoremap <leader>gw <cmd>Gwrite<CR>

        " Quickfix list
        nnoremap <leader>cf <cmd>cfirst<CR>
        nnoremap <leader>cn <cmd>cnext<CR>
        nnoremap <leader>cp <cmd>cprevious<CR>
        nnoremap <leader>cl <cmd>clast<CR>
        nnoremap <leader>co <cmd>copen<CR>
        nnoremap <leader>cw <cmd>cdo bd | update<CR>
        nnoremap <leader>cq <cmd>cfdo bd<CR>
        nnoremap <leader>cw <cmd>cdo bd | update<CR>
        nnoremap <leader>cx <cmd>cfdo bd | update<CR>
        nnoremap <leader>cq <cmd>cfdo bd<CR><cmd>cclose<CR>
        nnoremap <leader>ci :vimgrep<space>
        nnoremap <leader>c<leader> :cdo<space>

        " Keep it centered (thanks Prime)
        nnoremap n nzzzv
        nnoremap N Nzzzv
        nnoremap J mzJ`z

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
        -- https://github.com/David-Kunz/gen.nvim
        require('gen').setup({
          model = "llama3:latest", -- The default model to use.
          host = "localhost", -- The host running the Ollama service.
          port = "11434", -- The port on which the Ollama service is listening.
          quit_map = "q", -- set keymap for close the response window
          retry_map = "<c-r>", -- set keymap to re-send the current prompt
          init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
          -- Function to initialize Ollama
          command = function(options)
              local body = {model = options.model, stream = true}
              return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
          end,
          -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
          -- This can also be a command string.
          -- The executed command must return a JSON object with { response, context }
          -- (context property is optional).
          -- list_models = '<omitted lua function>', -- Retrieves a list of model names
          display_mode = "float", -- The display mode. Can be "float" or "split".
          show_prompt = false, -- Shows the prompt submitted to Ollama.
          show_model = false, -- Displays which model you are using at the beginning of your chat session.
          no_auto_close = false, -- Never closes the window automatically.
          debug = false -- Prints errors and the command which is run.
        })
        EOF

        lua << EOF
        -- enable color scheme
        require('onedark').setup({
          style = 'deep',
        })
        require('onedark').load()
        EOF

        ${treesitterContextCfg}

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
            'clangd',
            'lua_ls',
            'yamlls',
            'rust_analyzer',
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

        -- Configure Nix manually due to non-generic setup

        require('lspconfig').nil_ls.setup({
          autostart = true,
          cmd = { "nil" },
          settings = {
            ['nil'] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        });

        -- do this one manually due to custom cmd
        nvim_lsp['elixirls'].setup {
          cmd = { "elixir-ls" },
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
        EOF
      '';
    };
  };
}
