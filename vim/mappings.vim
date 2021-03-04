"navigation on a window
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

" switching between buffers
" nnoremap <silent> <C-N> :bp<CR>
" nnoremap <silent> <C-M> :bn<CR>

" Damian Conway's suggestion. Why not?
nnoremap ; :

" FZF
nnoremap <silent> <Space>T :NERDTreeToggle<CR>
nnoremap <silent> <Space>t :BTags<CR>
nnoremap <silent> <Space>f :ListFiles<CR>
nnoremap <silent> <Space>F :Files<CR>
nnoremap <silent> <Space>b :Buffers<CR>
nnoremap <silent> <Space>h :History<CR>
nnoremap <silent> <Space>c :Commands<CR>
nnoremap <Space>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <silent> <Space>s :Rg <C-r><C-w><CR>

" go to latest opened buffer
noremap <silent> <Space><Tab> :e #<CR>

" when in normal mode, stop highlighting search results
nnoremap <silent> <Esc> :noh<CR>

let leader=" "

" deoplete completion on tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" saving with control + s
nnoremap <C-S> :w<CR>

" ALE linting navigation
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" write mode
map <silent> <Space>z :WriteMode<CR>
