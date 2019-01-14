" navigation on a window
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" switching between buffers
nnoremap <silent> <C-N> :bp<CR>
nnoremap <silent> <C-M> :bn<CR>

" Damian Conway's suggestion. Why not?
nnoremap ; :

" FZF
nnoremap <silent> <Space>t :BTags<CR>
nnoremap <silent> <Space>T :Tags<CR>
nnoremap <silent> <Space>f :GFiles<CR>
nnoremap <silent> <Space>F :Files<CR>
nnoremap <silent> <Space>b :Buffers<CR>
nnoremap <silent> <Space>h :History<CR>
nnoremap <silent> <Space>c :Commands<CR>

" go to definition of functions, vars, etc
nnoremap <silent> <Space>d :ALEGoToDefinition<CR>zz

" go to latest opened buffer
nnoremap <silent> <Space><Tab> :e #<CR>

nmap <F8> :TagbarToggle<CR>

" when in normal mode, stop highlighting search results
nnoremap <silent> <Esc> :noh<CR>

let leader=" "
