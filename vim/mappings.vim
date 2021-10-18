" FZF
" nnoremap <silent> <Space>ft :BTags<CR>
" nnoremap <silent> <Space>fh :History<CR>
" nnoremap <silent> <Space>ff :Files<CR>
" nnoremap <silent> <Space>pf :ListFiles<CR>
" nnoremap <silent> <Space>bb :Buffers<CR>
" nnoremap <silent> <Space>cc :Commands<CR>
"nnoremap <Space>r :%s/\<<C-r><C-w>\>//g<Left><Left>
" nnoremap <silent> <Space>s :Rg <C-r><C-w><CR>

" deoplete completion on tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" ALE linting navigation
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)
