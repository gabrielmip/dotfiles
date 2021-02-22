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
set hid

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

" function used in SwapWords
function! Mirror(dict)
  for [key, value] in items(a:dict)
      let a:dict[value] = key
  endfor
  return a:dict
endfunction

function! S(number)
  return submatch(a:number)
endfunction

" swap words in file
" :call SwapWords({'foo':'bar'})
function! SwapWords(dict, ...)
  let words = keys(a:dict) + values(a:dict)
  let words = map(words, 'escape(v:val, "|")')
  if(a:0 == 1)
    let delimiter = a:1
  else
    let delimiter = '/'
  endif
  let pattern = '\v(' . join(words, '|') . ')'
  exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction

" Show syntax highlighting groups for word under cursor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()

" Kills all buffers but reopens the current one
function! KillBuffs()
  %bd|e#
endfunction

function! WriteMode()
  if !exists('g:write_mode_active')
    let g:write_mode_active = 1
  else
    let g:write_mode_active = !g:write_mode_active
  endif

  if g:write_mode_active == 1
    map j gj
    map k gk
    map $ g$
    map 0 g0
    set wrap
    set linebreak
    set nolist
    set textwidth=80
  else
    nunmap j
    nunmap k
    nunmap $
    nunmap 0
    set nowrap
    set textwidth=0
  endif
endfunction

command -nargs=0 WriteMode call WriteMode()

source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim

" It looks like this setting is being overwritten by a plugin or something.
" set conceallevel=0
let g:vim_json_syntax_conceal = 0

