" vim-polyglot {{{
" disabling most commands ran automatically per file type.
" i only want the syntax highlighting and autoindent.
let g:polyglot_disabled = ['sensible', 'ftdetect', 'sql.plugin', 'xml.plugin']
let g:markdown_folding = 1
" }}}

" Installed plugins {{{
call plug#begin('~/.config/nvim/bundle/')

Plug 'vim-airline/vim-airline' " statusline
Plug 'vim-airline/vim-airline-themes' " statusline colorscheme

" colorschemes
Plug 'ajmwagar/vim-deus'
Plug 'morhetz/gruvbox'

Plug 'airblade/vim-gitgutter' " git edit signs on the left column
Plug 'tpope/vim-fugitive' " git helpers

Plug 'ludovicchabant/vim-gutentags' " manages my tags
Plug 'dense-analysis/ale'  " linters and fixers
Plug 'neovim/nvim-lspconfig' " auto configuration for lsp servers
Plug 'williamboman/mason.nvim' " auto install lsp servers
Plug 'williamboman/mason-lspconfig.nvim' 

Plug 'mhinz/vim-startify' " home screen

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'

" snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " fuzzy search for navigation (tags, files, buffers)
Plug 'ojroques/nvim-lspfuzzy' " using fzf to show code actions, references, from lsp
Plug 'preservim/nerdtree' " file tree explorer

Plug 'Olical/conjure' " repl connection for lisps
Plug 'mboughaba/i3config.vim' " highlight for i3 config files
Plug 'nathangrigg/vim-beancount' " highlight and others for beancount files

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
let g:airline#extensions#tabline#enabled = 0
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
autocmd Filetype json,clojure,scheme,fennel,racket,lisp,markdown,text :IndentLinesDisable
" }}}

" ALE - Linter {{{
let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 0
let g:ale_set_highlights = 0
nnoremap <Space>fo :ALEFix<CR>

function! JokerFormatter(buffer) abort
    return {
    \   'command': 'joker --format -'
    \}
endfunction

execute ale#fix#registry#Add(
  \ 'joker-format',
  \ 'JokerFormatter',
  \ ['clojure'],
  \ 'joker fixer for clojure'
\)

let g:ale_python_black_options = '-l 79'
let g:ale_javascript_prettier_options = '--prose-wrap always'
let g:ale_sql_pgformatter_options = '--wrap-limit 68'
let g:ale_fixers = {
  \ 'javascript': ['prettier'],
  \ 'javascriptreact': ['prettier'],
  \ 'markdown': ['prettier'],
  \ 'json': ['prettier'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \ 'python': ['black'],
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
let g:cmp_is_enabled = v:true

lua <<EOF
local cmp = require'cmp'

cmp.setup({

  enabled = function()
    return vim.g.cmp_is_enabled
  end,

  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),

  sources = cmp.config.sources({
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  }, {
    { name = 'buffer', keyword_length = 3 },
  }),

})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', max_item_count = 10 }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
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

" lsp configs and cmp-nvim-lsp {{{
lua << EOF

local on_attach = function(client, _)
  -- disable treesitter highlighting since it does not work well with
  -- my colorscheme
  client.server_capabilities.semanticTokensProvider = nil

  local opts = { noremap=true, silent=true }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>lh', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>le', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[e', vim.lsp.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']e', vim.lsp.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>lca', vim.lsp.buf.code_action, opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "vimls",
    "tsserver",
    "cssls",
    "clojure_lsp",
    "eslint",
    "html",
    "pyright",
    "svelte",
    "yamlls",
    "beancount",
    "bashls"
  },
  
  capabilities = capabilities,

  handlers = {
    -- default handler
    function (server_name)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
        }
    end,
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        underline = false,
        signs = true,
        virtual_text = false,
        float = {
            scope = "line"
        }
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
if has("termguicolors")
    set termguicolors
endif

if exists('python_highlight_all')
    unlet python_highlight_all
endif

if exists('python_highlight_space_errors')
    unlet python_highlight_space_errors
endif


let g:gruvbox_invert_selection = 0

let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_palette = 'mixed'

colorscheme gruvbox
let g:indentLine_color_gui = '#44474f'
" }}}

" AutoPairs {{{
let g:AutoPairsShortcutToggle = ''
" }}}

"" GUIs {{{
let g:neovide_cursor_animation_length=0.03
let g:neovide_cursor_trail_length=0
let s:fontsize = 12
set guifont="Fira Code:h12"

function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Fira Code:h" . s:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
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

" NERDtree {{{
let NERDTreeShowHidden=1
" }}}

" Startify {{{
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:ascii = [
    \ '        __',
    \ '.--.--.|__|.--------.',
    \ '|  |  ||  ||        |',
    \ ' \___/ |__||__|__|__|',
    \ ''
    \]
let g:startify_custom_header = startify#pad(g:ascii)
" }}}
