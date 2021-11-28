set background=dark
let g:colors_name="skr"
" flush the package cache
lua package.loaded['skr.color'] = nil
" include our theme file and pass it to lush to apply
lua require('lush')(require('skr.color'))
