set nu rnu 
syntax on               " syntax highlighting
set vb
filetype on

"TABS
set expandtab           " enter spaces when tab is pressed
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set smarttab

"IDENT
set autoindent          " copy indent from current line when starting a new line
set si                  "Smart indent

"TEXT
"set textwidth=120       " break lines when line length increases
set colorcolumn=80      " 80 Charcter highlight

"Show Special characters
":set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
":set list
set nowrap

" BACKSPACE
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" STATUSLINE
set laststatus=2 " Always show the status line
" Format the status line
set statusline=\%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set ruler                           " show line and column number
set showcmd             " show (partial) command in status line

"SEARCH
set hlsearch
hi Search ctermbg=DarkBlue
hi Search ctermfg=LightYellow
set incsearch
set ignorecase
set smartcase

"WRAP MODE with visual line nav, toggle with \w
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
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
    setlocal wrap linebreak nolist columns=80 colorcolumn=0 
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

