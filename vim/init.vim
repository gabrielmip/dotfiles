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
set shiftwidth=2
set softtabstop=2
set expandtab
set nowrap
set showmatch
set smartcase
set hlsearch
set incsearch
set inccommand=nosplit
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set splitbelow
set splitright

autocmd ColorScheme janah highlight Normal ctermbg=235
colorscheme janah

" make the 101st column stand out
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%101v', 100)

" Always turn on syntax highlighting for diffs 
" EITHER select by the file-suffix directly...
augroup PatchDiffHighlight
  autocmd!
  autocmd BufEnter  *.patch,*.rej,*.diff   syntax enable
augroup END

" OR ELSE use the filetype mechanism to select automatically...
filetype on
augroup PatchDiffHighlight
  autocmd!
  autocmd FileType  diff   syntax enable
augroup END


source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim
