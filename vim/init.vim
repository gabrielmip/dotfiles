syntax on
filetype indent on " enable file type specific indentation
filetype plugin on

source $HOME/.config/nvim/plugins.vim

" indentation
set softtabstop=4 " number of spaces per tab while editing.
set shiftwidth=4
set expandtab " expand to 4 spaces when you press tab.
set autoindent " automatically indent lines while editing.

" splits
set splitbelow
set splitright

" search and replace
set ignorecase
set smartcase " ignore results' case if the search term is all lower case
set incsearch " search and highlight result as you type
set inccommand=nosplit " live preview in replace results

set number relativenumber
set hidden " allows user to leave unsaved buffers
set confirm " ask for confirmation in certain operations
set showmatch " briefly show matching parenthesis, brackets, etc
set history=1000 " press q: to see the history of commands and q/ for searches
set wildignore=*.swp,*.bak,*.pyc,*.class,.git/*,node_modules/*,tags,vendor/*,tmp/*,bin/*
set title " set the title of the terminal window to the name of the file I am editing
set mouse=nvi " enables mouse in normal, visual and insert mode. Hold shift to disable temporarily
set signcolumn=yes:2 " always show 2 additional columns for git signs and linter
set wildmenu " menu which display options for autocomplete over the status line
set path+=** " Allowing :find function to find in every subfolder recursively
set conceallevel=0
set nowrap " do not break lines when they are bigger than the screen

set colorcolumn=80 " highlight 80th column
                   " change color like :hi ColorColumn ctermbg=NONE ctermfg=red

" increase the time vim waits between keystrokes before it discard mappings and
" proceed with the default behavior for the keys.
set timeoutlen=10000 " 10 seconds

" turn off swap files and backups
set noswapfile
set nobackup
set nowritebackup

" code folding
set foldenable
set foldlevelstart=0 " defaults to close
set foldnestmax=10 " folds can be nested, this ensures max 10 nested folds.
set foldmethod=marker " my default: folding based on the marker.

" setting ripgrep as the preferred grep tool
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m

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

" Kills all buffers then reopens the current one
function! KillOtherBuffers()
  %bd|e#
endfunction

command! -nargs=0 KillOtherBuffers call KillOtherBuffers()

" Copy the file path for the current buffer
command! CopyBuffer let @+ = expand('%')
command! CopyBufferAbsolutePath let @+ = expand('%:p')

function! ListFiles()
  if isdirectory(expand(getcwd() . '/.git'))
    :GFiles
  else
    :Files
  endif
endfunction

command! -nargs=0 ListFiles call ListFiles()

function LocalWriteMode()
  setlocal wrap
  setlocal linebreak
  setlocal nolist
  setlocal textwidth=80
  setlocal foldlevel=99
endfunction

command! -nargs=0 LocalWriteMode call LocalWriteMode()

" automatically setting wrap on text and markdown files
autocmd FileType markdown,textfile call LocalWriteMode()

let leader=" "
let maplocalleader="," " this is for buffer-specific mappings (conjure uses this)
nnoremap <SPACE> <Nop>

" keeping the indentation (white spaces) when going to normal mode even if
" have not written any word.
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>

" Ctrl-Backspace to delete a word in insert, command and terminal mode
" Does not work with nvim-cmp
noremap! <C-BS> <C-w>
noremap! <C-H> <C-w>
tnoremap <C-BS> <C-w>
tnoremap <C-H> <C-w>

" Remove items from the quickfix list using `dd`.
" Source: https://stackoverflow.com/a/74675717
function! RemoveQFItem(mode) range abort
  let l:qf_list = getqflist()

  " distinguish mode for getting delete index and delete count
  if a:mode == 'v'
    let l:del_qf_idx = getpos("'<")[1] - 1
    let l:del_ct = getpos("'>")[1] - l:del_qf_idx
  else
    let l:del_qf_idx = line('.') - 1
    let l:del_ct = v:count > 1 ? v:count : 1
  endif

  " delete lines and update quickfix
  for item in range(l:del_ct)
    call remove(l:qf_list, l:del_qf_idx)
  endfor
  call setqflist(l:qf_list, 'r')

  if len(l:qf_list) > 0
    execute l:del_qf_idx + 1 . 'cfirst'
    copen
  else
    cclose
  endif
endfunction

autocmd FileType qf nmap <buffer> dd :call RemoveQFItem('n')<cr>
autocmd FileType qf vmap <buffer> dd :call RemoveQFItem('v')<cr>

" quickfix and location list navigation
function! QFHistory(goNewer)
  " Get dictionary of properties of the current window
  let wininfo = filter(getwininfo(), {i,v -> v.winnr == winnr()})[0]
  let isloc = wininfo.loclist
  " Build the command: one of colder/cnewer/lolder/lnewer
  let cmd = (isloc ? 'l' : 'c') . (a:goNewer ? 'newer' : 'older')
  try | execute cmd | catch | endtry
endfunction

" moving back and fourth in quickfix/location list history
" when in the list's buffer
autocmd FileType qf nnoremap <buffer> <Left> :call QFHistory(0)<CR>
autocmd FileType qf nnoremap <buffer> <Right> :call QFHistory(1)<CR>

" always open the quickfix window in the bottom using full width
autocmd FileType qf wincmd J

" load package to filter quickfix items
packadd cfilter

" quickfix list navigation
nnoremap ]c :cnext<CR>
nnoremap [c :cprev<CR>

" location list navigation
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>

" buffer navigation
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>
nnoremap <Space>bq :KillOtherBuffers<CR>

" tab navigation
nnoremap ]t :tabNext<CR>
nnoremap [t :tabprevious<CR>

" git change (hunk) navigation
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>

function! RemoveConflictMarkers()
  norm j
  let firstline = search('<<<<<<<', 'b')
  let lastline = search('>>>>>>>')
  execute firstline.','.lastline . ' g/^<\{7}\|^|\{7}\|^=\{7}\|^>\{7}/d'
endfunction

" vim-fugitive
nnoremap <Space>gs :G<CR>
nnoremap <Space>gl :diffget //3<CR>
nnoremap <Space>gh :diffget //2<CR>
nnoremap <Space>gg :call RemoveConflictMarkers()<CR>
nnoremap <Space>gpoh :!git push origin HEAD<CR>

" git-messenger
nmap <Space>gm <Plug>(git-messenger)

" git revision history navigation
" comes from plugin/fugitive_revision_history.vim
nnoremap <silent> <Space>gr :call ToggleRevisionComparison()<CR>
nnoremap <silent> ]r :call OlderRevision()<CR>
nnoremap <silent> [r :call NewerRevision()<CR>

" FZF mappings
nnoremap <silent> <Space>ft :BTags<CR>
nnoremap <silent> <Space>fh :History<CR>
nnoremap <silent> <Space>ff :Files<CR>
nnoremap <silent> <Space>pt :Tags<CR>
nnoremap <silent> <Space>pf :ListFiles<CR>
nnoremap <Space>bb :buffers<CR>:buffer<Space>
nnoremap <silent> <Space>cc :Commands<CR>

" Reload vim config (cr = config reload)
noremap <Space>cr :source $HOME/.config/nvim/init.vim

" project explorer
function! OpenExplorer()
  if &filetype ==# 'startify'
    NERDTree
  else
    NERDTreeFind
  endif
endfunction

nnoremap <silent> <Space>pe :call OpenExplorer()<cr>
nnoremap <silent> <Space>pq :NERDTreeClose<cr>

" search results appear in the middle of the screen whenever possible
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" there will be at least 7 lines below and above the cursor whenever possible
" set scrolloff=7

" search the word under the cursor in the project
nnoremap <Space>ps :Rg <C-r><C-w><CR>
" search the selection in the project
xnoremap <Space>ps "sy:Rg <C-r>s<CR>
" search the selection in the file
xnoremap <Space>fs "sy/<C-r>s<CR>

" replace the word under the cursor in the current file
nnoremap <Space>fr :%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>
" replace the selection in the current file
xnoremap <Space>fr "sy:%s/<C-r>s/<C-r>s/g<Left><Left>

" go to latest opened buffer
noremap <silent> <Space><Tab> :e #<CR>

" when in normal mode, stop highlighting search results
nnoremap <silent> <Esc> :nohlsearch<CR>

" saving with control + s
nnoremap <C-S> :w<CR>

" Damian Conway's suggestion. Why not?
nnoremap ; :
