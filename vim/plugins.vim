" vim-polyglot {{{
" disabling most commands ran automatically per file type.
" i only want the syntax highlighting and autoindent.
let g:polyglot_disabled = ['sensible', 'ftdetect']
" }}}

" Installed plugins {{{
call plug#begin('~/.config/nvim/bundle/')

Plug 'vim-airline/vim-airline' " statusline
Plug 'vim-airline/vim-airline-themes' " statusline colorscheme

" colorschemes
Plug 'ajmwagar/vim-deus'
Plug 'morhetz/gruvbox'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'sainnhe/sonokai'
Plug 'colepeters/spacemacs-theme.vim'
Plug 'tyrannicaltoucan/vim-deep-space'

Plug 'airblade/vim-gitgutter' " git edit signs on the left column
Plug 'tpope/vim-fugitive' " git helpers

Plug 'ludovicchabant/vim-gutentags' " manages my tags
Plug 'dense-analysis/ale'  " linters and fixers
Plug 'neovim/nvim-lspconfig' " auto configuration for lsp servers
Plug 'williamboman/nvim-lsp-installer' " auto install lsp servers

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'ms-jpq/chadtree'

Plug 'Olical/conjure' " repl connection for lisps

" Plug 'voldikss/vim-floaterm' " terminal in a floating window

Plug 'sheerun/vim-polyglot' " bundle for language syntax
Plug 'Yggdroot/indentLine' " adds character to mark indentation
Plug 'editorconfig/editorconfig-vim' " uses .editorconfig to override editor configs
Plug 'ap/vim-css-color' " sets background to the html color token
Plug 'mattn/emmet-vim' " abbreviations for HTML insertion
Plug 'tpope/vim-commentary' " bindings to comment blocks and motions
Plug 'tpope/vim-surround' " bindings to edit surrounding brackets, parenthesis
Plug 'tpope/vim-repeat' " enables repeating plugin actions with the dot .
Plug 'arthurxavierx/vim-caser' " convert word cases with motions
Plug 'jiangmiao/auto-pairs' " adds closing parenthesis
Plug 'mboughaba/i3config.vim' " highlight for i3 config files

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " fuzzy search for navigation (tags, files, buffers)
Plug 'ojroques/nvim-lspfuzzy' " using fzf to show code actions, references, from lsp

call plug#end()
" }}}

" vim-airline {{{
let g:airline_theme='gruvbox'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#languageclient#enabled = 1

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

" indentLine {{{
let g:indentLine_char = '▏'
autocmd Filetype json,clojure,scheme,fennel,racket,lisp :IndentLinesDisable
" }}}

" ALE - Linter {{{
let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

function! JokerFormatter(buffer) abort
    return {
    \   'command': 'joker --format -'
    \}
endfunction

execute ale#fix#registry#Add('joker-format', 'JokerFormatter', ['clojure'], 'joker fixer for clojure')

let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_fixers = {
  \ 'javascript': ['prettier'],
  \ 'javascriptreact': ['prettier'],
  \ 'markdown': ['prettier'],
  \ 'json': ['prettier'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \ 'clojure': ['joker-format'],
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
   \ 'javascript': ['eslint'],
   \ 'javascriptreact': ['eslint'],
   \ 'python': ['pylint'],
   \ 'clojure': ['clj-kondo', 'joker'],
   \ 'typescript': ['eslint'],
   \ 'typescriptreact': ['eslint']
   \}

let g:ale_root = {
   \ 'pylint': './src',
   \}
"}}}

" nvim-cmp {{{
set completeopt=menu,menuone,noselect
set pumheight=15

lua <<EOF
local cmp = require'cmp'

cmp.setup({

  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm {
        select = false,
    },
    ['<C-y>'] = cmp.mapping.confirm {
        select = false,
    },
  },

  sources = cmp.config.sources({
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 }
  }),

})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer', max_item_count = 10 }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path', max_item_count = 10 }
  }, {
    { name = 'cmdline', max_item_count = 10 }
  })
})
EOF
" }}}

" vim-snip {{{

let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" }}}

" nvim-lspconfig {{{
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gd', "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap('n', 'gh', "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>ld', "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap('n', '<space>lt', "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap('n', '<space>lh', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap('n', '<space>ln', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap('n', '<F2>', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap('n', '<space>le', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '<space>lq', "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap('n', '<space>lf', "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap('n', '[e', "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap('n', ']e', "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap('n', '<space>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local util = require("lspconfig/util")
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = on_attach
    }

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        underline = false,
    }
)

EOF
" }}}

" FZF {{{
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_tags_command = 'ctags -R --exclude={tags,assets,node_modules,vendor,tmp,bin,.transpiled,.git}'

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

"attaching results from lsp to FZF
lua require('lspfuzzy').setup {}

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

colorscheme gruvbox
" highlight Visual     guifg=None guibg=#545760
" highlight MatchParen guifg=NONE guibg=#6c707a
let g:indentLine_color_gui = '#44474f'
" }}}

" AutoPairs {{{
let g:AutoPairsShortcutToggle = ''
" }}}

"" GUIs {{{
"let g:neovide_cursor_animation_length=0.03
"let g:neovide_cursor_trail_length=0
"set guifont=Fira\ Code:h14
"" }}}

" Emmet {{{
let g:user_emmet_settings = {
\  'typescript' : {
\      'extends' : 'jsx',
\  },
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\  'less': {
  \ 'extends' : 'css'
  \}
\}
" }}}

" vim-floaterm {{{
let g:floaterm_width = 1.0
let g:floaterm_height = 0.3
let g:floaterm_position = 'bottom'
" }}}

" chadtree {{{
" }}}
