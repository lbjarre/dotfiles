" VIMRC
" A lot of this stuff is things that I don't fully understand, it's so easy to
" just copy-n-paste stuff off the internet.
"
let mapleader = "\<Space>"

let $GIT_TERMINAL_PROMPTS=1

" Plugins
call plug#begin('~/.config/nvim/plugged')

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Other stuff
Plug 'glepnir/indent-guides.nvim'
Plug 'rhysd/git-messenger.vim'
Plug 'mhinz/vim-startify'
Plug 'machakann/vim-highlightedyank'
Plug 'justinmk/vim-dirvish'

" Church of Tpope
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Lang specific plugins
Plug 'cespare/vim-toml'
Plug 'b4b4r07/vim-hcl'
Plug 'rescript-lang/vim-rescript'

call plug#end()

filetype plugin indent on
syntax on

" Looks & feel
set background=light
colorscheme dim

" Custom statusline
lua require('skr.statusline')

" colorcolumns
set colorcolumn=80,100
highlight ColorColumn ctermbg=230

" whitespace character diplay
set showbreak=↪\
set listchars=tab:\ \ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
" Good alternative setting for tab listchar: "tab:→\ "
" I think it adds a bit too much noise in tab-indented languages though
set list

" Startify
let g:startify_lists = [
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
    \ { 'type': 'files',     'header': ['   MRU'] },
    \ { 'type': 'commands',  'header': ['   Commands'] }
    \ ]
let g:startify_bookmarks = [
    \ '~/.config/nvim/init.vim',
    \ '~/.bashrc',
    \ ]
let g:startify_change_to_dir=0 " don't cd into the files dir

" Swapfiles are stupid
set noswapfile
set nobackup
set nowritebackup

set hidden
set showcmd
set autoindent
set nostartofline

" Line numbers: relative numbers, but show absolute number on the current line
set number
set relativenumber

set mouse=a
set noshowmode

" Default tab setup
set shiftwidth=4
set softtabstop=4
set expandtab

" Sensible splits
set splitright
set splitbelow

" timeout lens for sequences
set timeoutlen=1000
set ttimeoutlen=10

" leader-yank, yanks into the system clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y

" Autosource some files after writing
augroup autosource
    autocmd!
    autocmd BufWritePost ~/.config/nvim/init.vim so <sfile>
    autocmd BufWritePost ~/.bashrc !source <sfile>
augroup end

" Telescope
lua << EOF
require('telescope').setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        set_env = { ['COLORTERM'] = 'truecolor' },
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    }
}
--require('telescope').load_extension('fzy_native')
EOF
nnoremap <silent> <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <silent> <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <silent> <leader>/  <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find(require'telescope.themes'.get_ivy{ layout_config={prompt_position = "top"}, sorting_strategy = "ascending" })<CR>
nnoremap          <leader>fs <cmd>lua require('telescope.builtin').grep_string{ search = vim.fn.input("search: ") }<CR>
nnoremap          <leader>fl <cmd>lua require('telescope.builtin').lsp_workspace_symbols{ query = vim.fn.input("search: ") }<CR>

" indent
lua require('indent_guides').setup()

" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
}
EOF

" LSP setup
"
" Some settings to make the autocomplete more sensible (don't insert things
" willy nilly without me pressing any buttons etc)
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Setting up the servers
lua << EOF
local lspconfig = require('lspconfig')
local completion = require('completion')

-- Custom on_attach function
local on_attach = function(client)
    completion.on_attach(client) -- LSP based completions
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    -- Enable inlay hints for rust, thanks TJ!
    if filetype == 'rust' then
        vim.cmd(
            [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]]
              .. [[aligned = true, prefix = " » " ]]
            .. [[} ]]
        )
    end

    -- Enable autoformatting on some langs
    if vim.tbl_contains({'go', 'rust', 'haskell'}, filetype) then
        vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
    end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    require('lsp_extensions.workspace.diagnostic').handler, {
        signs = { severity_limit = "Error" },
     }
)

-- Setup and attach all servers
local lsp_servers = {
    'rust_analyzer',
    'gopls',
    'hls',
    'pylsp',
}
for _, server in ipairs(lsp_servers) do
    lspconfig[server].setup { on_attach = on_attach }
end
EOF

nnoremap dn         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap dp         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>la <cmd>lua require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_dropdown{})<CR>
nnoremap gd         <cmd>lua require'telescope.builtin'.lsp_definitions()<CR>
nnoremap gr         <cmd>lua require'telescope.builtin'.lsp_references()<CR>
nnoremap <leader>ld <cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<CR>
nnoremap <leader>ls <cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>

