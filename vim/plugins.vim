" vim-polyglot {{{
" disabling every command ran automatically per file type.
" i only want the syntax highlighting.
let g:polyglot_disabled = ['sensible', 'ftdetect', 'autoindent']
" }}}

" Installed plugins {{{
call plug#begin('~/.config/nvim/bundle/')

Plug 'vim-airline/vim-airline' " statusline
Plug 'vim-airline/vim-airline-themes' " statusline colorscheme

" colorschemes
Plug 'ajmwagar/vim-deus'
"Plug 'morhetz/gruvbox'
"Plug 'christianchiarulli/nvcode-color-schemes.vim'
"Plug 'romgrk/doom-one.vim'
Plug 'sainnhe/sonokai'

Plug 'airblade/vim-gitgutter' " git edit signs on the left column
Plug 'tpope/vim-fugitive' " git helpers

Plug 'ludovicchabant/vim-gutentags' " manages my tags
Plug 'dense-analysis/ale'  " linters and fixers
"Plug 'neovim/nvim-lspconfig' " auto configuration for lsp servers
"Plug 'hrsh7th/nvim-compe' " completion engine
"Plug 'FateXii/emmet-compe' " sourcing emmet to nvim compe
"Plug 'hrsh7th/vim-vsnip' " snippet engine
"Plug 'hrsh7th/vim-vsnip-integ' " integration between snippets and completions

Plug 'Olical/conjure' " repl connection for lisps

Plug 'sheerun/vim-polyglot' " bundle for language syntax
Plug 'Yggdroot/indentLine' " adds character to mark indentation
Plug 'editorconfig/editorconfig-vim' " uses .editorconfig to override editor configs
Plug 'ap/vim-css-color' " sets background to the html color token
Plug 'mattn/emmet-vim' " abbreviations for HTML insertion
Plug 'tpope/vim-commentary' " bindings to comment blocks and motions
Plug 'tpope/vim-surround' " bindings to edit surrounding brackets, parenthesis
Plug 'arthurxavierx/vim-caser' " convert word cases with motions
"Plug 'jiangmiao/auto-pairs' " adds closing parenthesis

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " fuzzy search for navigation (tags, files, buffers)

call plug#end()
" }}}

" vim-airline {{{
let g:airline_theme='deus'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
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
autocmd Filetype json,clojure :IndentLinesDisable
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
"}}}

"" Neovim LSP nvim-lspconfig {{{
"lua << EOF
"local nvim_lsp = require('lspconfig')
"local on_attach = function(client, bufnr)
"  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
"
"  -- Mappings.
"  local opts = { noremap=true, silent=true }
"  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"  buf_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"  buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"  buf_set_keymap('n', '<space>gca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
"  buf_set_keymap('n', '<C-j>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
"
"  -- highlight symbol on cursor hover
"  if client.resolved_capabilities.document_highlight then
"    vim.api.nvim_exec([[
"      hi LspReferenceRead cterm=bold ctermbg=red guibg=#545760
"      hi LspReferenceText cterm=bold ctermbg=red guibg=#545760
"      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#545760
"      augroup lsp_document_highlight
"        autocmd! * <buffer>
"        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
"        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
"      augroup END
"    ]], false)
"  end
"end
"
"-- Neovim does not include built-in snippets. See:
"-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#html
"-- Use a loop to conveniently both setup defined servers
"-- and map buffer local keybindings when the language server attaches
"local serversWithDefaultConfig = {
"  'pyls',
"  'svelte',
"  'tsserver',
"  'clojure_lsp',
"  'vimls',
"  'bashls',
"  'jsonls',
"  'html',
"  'cssls'
"}
"
"local capabilities = vim.lsp.protocol.make_client_capabilities()
"capabilities.textDocument.completion.completionItem.snippetSupport = true
"capabilities.textDocument.completion.completionItem.resolveSupport = {
"  properties = {
"    'documentation',
"    'detail',
"    'additionalTextEdits',
"  }
"}
"
"for _, lsp in ipairs(serversWithDefaultConfig) do
"  nvim_lsp[lsp].setup {
"    capabilities = capabilities,
"    on_attach = on_attach,
"  }
"end
"EOF
"
"" }}}
"
"" nvim-compe {{{
"set completeopt=menuone,noselect,noinsert
"let g:compe = {}
"let g:compe.enabled = v:false
"let g:compe.documentation = v:true
"
"let g:compe.source = {}
"let g:compe.source.path = v:true
"let g:compe.source.buffer = v:true
"let g:compe.source.spell = v:true
"let g:compe.source.tags = v:true
"let g:compe.source.nvim_lsp = v:true
"let g:compe.source.ultisnips = v:true
"let g:compe.source.emmet = v:true
"
"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
"highlight link CompeDocumentation NormalFloat
"
"" meant to add Tab and Shift-tab for navigation in the completion menu {{{
"lua << EOF
"local t = function(str)
"  return vim.api.nvim_replace_termcodes(str, true, true, true)
"end
"
"local check_back_space = function()
"    local col = vim.fn.col('.') - 1
"    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
"        return true
"    else
"        return false
"    end
"end
"
"-- Use (s-)tab to:
"--- move to prev/next item in completion menuone
"--- jump to prev/next snippet's placeholder
"_G.tab_complete = function()
"  if vim.fn.pumvisible() == 1 then
"    return t "<C-n>"
"  elseif vim.fn.call("vsnip#available", {1}) == 1 then
"    return t "<Plug>(vsnip-expand-or-jump)"
"  elseif check_back_space() then
"    return t "<Tab>"
"  else
"    return vim.fn['compe#complete']()
"  end
"end
"_G.s_tab_complete = function()
"  if vim.fn.pumvisible() == 1 then
"    return t "<C-p>"
"  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
"    return t "<Plug>(vsnip-jump-prev)"
"  else
"    return t "<S-Tab>"
"  end
"end
"
"vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
"
"EOF
"" }}}
"
"" }}}

" FZF {{{
" let g:fzf_layout = { 'down': '~40%' }
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

colorscheme deus
highlight Visual     guifg=None guibg=#545760
highlight MatchParen guifg=NONE guibg=#6c707a
let g:indentLine_color_gui = '#545760'
" }}}

"" AutoPairs {{{
"let g:AutoPairsShortcutToggle = ''
"" }}}

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

" vim-fugitive {{{
nnoremap <Space>gs :G<CR>
nnoremap <Space>gl :diffget //3<CR>
nnoremap <Space>gh :diffget //2<CR>
" }}}
