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
set inccommand=nosplit " live preview in replace results
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set splitbelow
set splitright
set hid
set colorcolumn=81
set mouse=a

set wildmenu
set path+=**

" Omnicompletion
" filetype plugin on
set omnifunc=syntaxcomplete#Complete

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

" function used in SwapWords
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

" Kills all buffers then reopens the current one
function! KillBuffs()
  %bd|e#
endfunction

function! ListFiles()
  if isdirectory(expand(getcwd() . '/.git'))
    :GFiles
  else
    :Files
  endif
endfunction

if !exists(':ListFiles')
  command -nargs=0 ListFiles call ListFiles()
endif

if !exists(':KillBuffs')
  command -nargs=0 KillBuffs call KillBuffs()
endif

function LocalWriteMode()
  setlocal wrap
  setlocal linebreak
  setlocal nolist
  setlocal textwidth=80
endfunction

source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim

" It looks like this setting is being overwritten by a plugin or something.
let g:vim_json_syntax_conceal = 0
autocmd FileType json set foldmethod=syntax
autocmd FileType vim set foldmethod=marker
autocmd FileType markdown set conceallevel=0

highlight! link TSFunctionMacro Red
highlight! link TSFuncBuiltin Red
highlight! link TSVariableBuiltin White
highlight! link TSParameter Orange
highlight! link TSFunction White

" Automatically setting wrap on text and markdown files
autocmd FileType markdown,textfile call LocalWriteMode()
