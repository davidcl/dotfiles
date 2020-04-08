set nocompatible              " be iMproved, required
filetype off                  " required
set tw=0

filetype plugin indent on    " required
syntax on

" incremental search
:set path+=**
:set wildmenu
:set incsearch
:set hlsearch
" display the line numbers
:set number

"
" C++ development
" (powered by ALE and ccls)
"
let g:ale_linters = {'c': ['ccls'], 'cpp': ['ccls']}
let g:ale_completion_enabled = 1

nnoremap <silent> <C-d> :ALEGoToDefinition<CR>
nnoremap <silent> <C-r> :ALEFindReferences<CR>
nnoremap <silent> <C-a> :ALESymbolSearch<CR>
nnoremap <silent> <C-h> :ALEHover<CR>

"
" Rust development
" 

let g:rustfmt_autosave = 1


" indent with spaces
set expandtab
set shiftwidth=4
set softtabstop=4

" skeletons
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
    autocmd BufNewFile *.tst 0r ~/.vim/templates/skeleton.tst
  augroup END
endif

