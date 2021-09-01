" VIMRC
" A lot of this stuff is things that I don't fully understand, it's so easy to
" just copy-n-paste stuff off the internet.
"
let mapleader = "\<Space>"

let $GIT_TERMINAL_PROMPTS=1

filetype plugin indent on
syntax on

lua require('skr')

" Looks & feel
set background=dark
colorscheme default

" colorcolumns
set colorcolumn=80,100
highlight ColorColumn ctermbg=235
highlight NormalFloat ctermbg=239

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
set timeoutlen=500
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

" LSP setup
" Some settings to make the autocomplete more sensible (don't insert things
" willy nilly without me pressing any buttons etc)
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

