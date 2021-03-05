set nocompatible
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')
Plugin  'VundleVim/Vundle.vim'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ajmwagar/vim-deus'

Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

Plugin 'ludovicchabant/vim-gutentags'
Plugin 'dense-analysis/ale'
Plugin 'Shougo/deoplete.nvim'

" requirements for deoplete
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'

Plugin 'sheerun/vim-polyglot'
Plugin 'plasticboy/vim-markdown'

Plugin 'Yggdroot/indentLine'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ap/vim-css-color'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'jiangmiao/auto-pairs'
Plugin 'arthurxavierx/vim-caser'

Plugin 'scrooloose/nerdTree'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

call vundle#end()

filetype plugin indent on

colorscheme deus

"------------[ vim-airline ]------------
let g:airline_theme='deus'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1

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

"------------[ IndentLine ]------------
let g:indentLine_char = '▏'
let g:indentLine_color_term = 229
autocmd Filetype json :IndentLinesDisable

"------------[ ALE - Linter ]------------
let g:ale_sign_column_always = 0
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_set_balloons = 1
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint']
\}
let g:ale_linters = {
  \ 'javascript': ['eslint', 'tsserver'],
  \ 'python': ['pyls'],
  \ 'typescript': ['eslint', 'tsserver']
\}

"------------[ Deoplete ]------------
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
\ '*': ['ale', 'tag', 'buffer'],
\})

"------------[ FZF ]------------
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_tags_command = 'ctags -R --exclude={tags,assets,node_modules,bower_components,test,lib,vendor,plugins,tmp,bin,.transpiled,.git}'

"------------[ Gutentags ]------------
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

"------------[ colorscheme ]------------
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

let g:indentLine_color_term = 241
let g:indentLine_color_gui = '#665c54'

"------------[ Markdown ]------------
let g:vim_markdown_conceal = 0

"------------[ AutoPairs ]-----------
let g:AutoPairsShortcutToggle = ''
