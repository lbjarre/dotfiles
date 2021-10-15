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

set colorcolumn=80,100
highlight ColorColumn ctermbg=235

highlight NormalFloat ctermbg=239
highlight Pmenu ctermbg=239 ctermfg=15

highlight Comment cterm=italic ctermfg=247
highlight Constant ctermfg=darkblue

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

" Default tab setup
set shiftwidth=4
set softtabstop=4
set expandtab

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
"set completeopt=menu,menuone,noinsert,noselect
"let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

