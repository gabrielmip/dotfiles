" Markdown {{{
let g:vim_markdown_conceal = 0
" }}}

set nocompatible
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')
Plugin  'VundleVim/Vundle.vim'

Plugin 'vim-airline/vim-airline' " statusline
Plugin 'vim-airline/vim-airline-themes' " statusline colorscheme
Plugin 'ajmwagar/vim-deus' " colorscheme
Plugin 'morhetz/gruvbox' " colorscheme
Plugin 'sainnhe/sonokai' " colorscheme

Plugin 'airblade/vim-gitgutter' " git edit signs on the left column
Plugin 'tpope/vim-fugitive' " git helpers

Plugin 'ludovicchabant/vim-gutentags' " manages my tags
Plugin 'dense-analysis/ale'  " linting
Plugin 'Shougo/deoplete.nvim'  " auto complete
Plugin 'prabirshrestha/vim-lsp'  " lsp client
Plugin 'mattn/vim-lsp-settings'  " lsp auto install
Plugin 'lighttiger2505/deoplete-vim-lsp'  " lsp source for deoplete
Plugin 'deathlyfrantic/deoplete-spell' " spell source for deoplete

Plugin 'roxma/nvim-yarp' " requirements for deoplete
Plugin 'roxma/vim-hug-neovim-rpc' " requirements for deoplete

Plugin 'Olical/conjure' " repl connection for lisps

Plugin 'sheerun/vim-polyglot' " bundle for language syntax

Plugin 'Yggdroot/indentLine' " adds character to mark indentation
Plugin 'editorconfig/editorconfig-vim' " uses .editorconfig to override
                                       " editor configs
Plugin 'ap/vim-css-color' " adds the color html colors to
Plugin 'tpope/vim-commentary' " bindings to comment blocks and motions
Plugin 'tpope/vim-surround' " bindings to edit surrounding brackets, parenthesis
Plugin 'jiangmiao/auto-pairs' " adds closing parenthesis

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim' " fuzzy search for navigation (tags, files, buffers)

call vundle#end()

filetype plugin indent on

" vim-airline {{{
let g:airline_theme='sonokai'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 0

if has('autocmd')
  augroup airline_init
    autocmd!
    autocmd User AirlineAfterInit call s:airline_init()
  augroup END
endif
function! s:airline_init()
  let g:airline_section_b = fnamemodify(getcwd(), ':t')
  let g:airline_section_y = airline#section#create(['hunks'])
endfunction
" }}}

" IndentLine {{{
let g:indentLine_char = '▏'
autocmd Filetype json,clojure :IndentLinesDisable
" }}}

" ALE - Linter {{{
let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 0
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
" let g:ale_floating_preview = 1
" let g:ale_set_balloons = 1
" let g:ale_hover_cursor = 1

let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'javascriptreact': ['eslint'],
  \ 'markdown': ['prettier'],
  \ 'json': ['prettier'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'typescript': ['eslint'],
  \ 'typescriptreact': ['eslint'],
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
  \ 'javascript': ['eslint', 'tsserver'],
  \ 'javascriptreact': ['eslint', 'tsserver'],
  \ 'python': ['pylint'],
  \ 'clojure': ['clj-kondo'],
  \ 'typescript': ['eslint', 'tsserver'],
  \ 'typescriptreact': ['eslint', 'tsserver']
\}
" }}}

" vim-lsp-settings {{{
" adding the src/ folder to what is said to be the defaults in the
" documentation
let g:lsp_settings_root_markers = [
\   'src/',
\   '.git',
\   '.git/',
\   '.svn',
\   '.hg',
\   '.bzr'
\ ]
" }}}

" vim-lsp {{{

let g:lsp_diagnostics_enabled = 0

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> gn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * silent! pclose!  " closes preview when completion is done
set completeopt+=preview
call deoplete#custom#option('max_list', 15) " limit number of suggestions shown
call deoplete#custom#option('sources', {
\ '*': ['vim-lsp', 'tag', 'spell','buffer'],
\})
" }}}

" FZF {{{
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_tags_command = 'ctags -R --exclude={tags,assets,node_modules,bower_components,test,lib,vendor,plugins,tmp,bin,.transpiled,.git}'

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist([], ' ', {
  \   'title': 'Seleção do FZF',
  \   'items': map(copy(a:lines),
  \   '{ "filename": v:val }')
  \   })
  copen
  cc
endfunction

let g:fzf_action = {
\  'ctrl-q': function('s:build_quickfix_list'),
\  'ctrl-t': 'tab split',
\  'ctrl-x': 'split',
\  'ctrl-v': 'vsplit',
\  }
" }}}

" Gutentags {{{
function! CtagsGenerator()
python3 << EOF

import os
import shutil
import subprocess
import sys

ctag_path = shutil.which("ctags")
if ctag_path is None:
  sys.exit("It looks like you dont have ctags installed, please install it before continuing")

git_folder_path = os.path.join(os.getcwd(), '.git')
git_folder_path_exists = os.path.isdir(git_folder_path)
if not git_folder_path_exists:
  sys.exit('The git folder was not found on root, tags will not be generated')

print('Generating tags')
tag_file_path = os.path.join(git_folder_path, 'tags')
tags_args = ['ctags', '-R', '-f', tag_file_path, '.']
subprocess.run(tags_args)
print('Tags generated successfully!')

EOF
endfunction

command! GenerateTags call CtagsGenerator()

"Gutentags options
let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_file_list_command = "rg --files --no-messages --glob='!{**/*.min.*,.git/*,**/*.html, **/*.map.*}'"
set tags+=./.git/tags
" }}}

" colorscheme {{{
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set t_Co=256
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    let g:deus_termcolors=256
  endif
endif

colorscheme sonokai
highlight Visual     guifg=None guibg=#545760
highlight MatchParen guifg=NONE guibg=#6c707a
let g:indentLine_color_gui = '#666a75'
" let g:indentLine_color_term = '237'
" highlight lspReference guifg=None guibg=#545760
" }}}


" AutoPairs {{{
let g:AutoPairsShortcutToggle = ''
" }}}

" GUIs {{{
let g:neovide_cursor_animation_length=0.03
let g:neovide_cursor_trail_length=0
set guifont=Fira\ Code:h14
" }}}
