
set nocompatible
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')
Plugin  'VundleVim/Vundle.vim'

Plugin 'mhinz/vim-startify'
Plugin 'vim-airline/vim-airline' 
Plugin 'vim-airline/vim-airline-themes' 
Plugin 'flazz/vim-colorschemes'

Plugin 'tpope/vim-fugitive'
Plugin 'zivyangll/git-blame.vim'
Plugin 'mhinz/vim-signify'

Plugin 'w0rp/ale'
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'

Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Yggdroot/indentLine'
Plugin 'ap/vim-css-color' 
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'

Plugin 'scrooloose/nerdTree'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

call vundle#end()
filetype plugin indent on


"------------[ vim-airline ]------------
let g:airline_theme='deus'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#ale#enabled = 1

"------------[ IndentLine ]------------
let g:indentLine_char = '⎸'
let g:indentLine_color_term = 239

"------------[ ALE - Linter ]------------
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1

"------------[ Deoplete ]------------
let g:deoplete#enable_at_startup = 1

"------------[ FZF ]------------
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_tags_command = 'ctags -R --exclude={assets,node_modules,bower_components,test,lib,vendor,plugins,tmp,bin,.transpiled,.git}'

