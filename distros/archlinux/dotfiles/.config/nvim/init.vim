set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" CONFIGS
" source ~/.vimrc
" source ~/.config/nvim/
source ~/.config/nvim/chadtree.vim
source ~/.config/nvim/neoterm.vim
source ~/.config/nvim/airline.vim

" PLUGINS
call plug#begin()
Plug 'rust-lang/rust.vim'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
Plug 'vimwiki/vimwiki' 
Plug 'kassio/neoterm'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()


" DEFAULTS
set mouse=a
set number relativenumber
set clipboard=unnamed
set tabstop=4
set shiftwidth=4
set expandtab
set colorcolumn=80
set spelllang=en,pt_br

" REMAPS
let mapleader = " "
noremap <esc> <c-\><c-n>
nnoremap <leader><tab> <cmd>CHADopen --nofocus<cr>
nnoremap <leader> t <cmd>Ttoggle resize=8<cr>
nnoremap <leader><leader> :b#<CR>
map <leader>w :call ToggleWrap()<CR>

" FUNCTIONS
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    setlocal spell
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist "columns=80 colorcolumn=0 
    setlocal nospell
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

