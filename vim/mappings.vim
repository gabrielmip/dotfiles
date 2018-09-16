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
nnoremap <silent> <C-T> :BTags<CR>
nnoremap <silent> <C-P> :GFiles<CR>

nmap <F8> :TagbarToggle<CR>
