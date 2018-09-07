set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')            " required
Plugin 'VundleVim/Vundle.vim'  " required
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-airline/vim-airline' 
Plugin 'vim-airline/vim-airline-themes' 
Plugin 'Yggdroot/indentLine'
Plugin 'valloric/youcompleteme'
Plugin 'scrooloose/nerdTree'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'

call vundle#end()            " required
filetype plugin indent on    " required

set runtimepath^=~/.config/nvim/bundle/vim-fugitive.vim

set runtimepath^=~/.config/nvim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif


syntax on
set backspace=indent,eol,start
set autoindent
set ruler
set nostartofline
set laststatus=2
set confirm

set number
set relativenumber
set cursorline

" Indentation with spaces. Tabs are transformed.
set shiftwidth=2
set softtabstop=2
set expandtab

set splitbelow
set splitright
" ctrl+J instead of ctrl+W+J
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <C-M> :bn<CR>
nnoremap <silent> <C-N> :bn<CR>

set nowrap
set showmatch     " set show matching parenthesis
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
colorscheme dracula


"""""""" VIM-AIRLINE """"""
set ttimeoutlen=50
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
"let g:airline_theme='powerlineish'

"""""""" INDENTLINE """""""""""
let g:indentLine_char = '⎸'
let g:indentLine_color_term = 239
