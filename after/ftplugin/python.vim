
packadd SimpylFold
packadd black
packadd isort-vim-2

if has("win32")
    let g:black_virtualenv='~/vimfiles/vim-env'
    let g:isort_virtualenv='~/vimfiles/vim-env'
else
    let g:black_virtualenv='~/.vim/vim-env'
    let g:isort_virtualenv='~/.vim/vim-env'
endif

" pylint
compiler pylint_vim_env
nnoremap <F5> :update<CR>:Make %<CR>
inoremap <F5> <esc>:update<CR>:Make %<CR>

" run in integrated terminal
nnoremap <F6> :update<CR>:term python %<CR>
inoremap <F6> <esc>:update<CR>:term python %<CR>

" last :term pytest command, if any. No <CR>
nnoremap <F7> :term pytest<t_ku>
inoremap <F7> <ESC>:term pytest<t_ku>


setlocal colorcolumn=89
setlocal textwidth=85
setlocal formatoptions-=t  " do not autowrap text

" open files with all folds open. Should be just enough so that one zm will
" fold something. Will need to be tweaked as new folding code or plugins are
" used.
au filetype python setlocal foldlevel=3

" run Black and MyPy
nmap <buffer> <leader>b :update<CR>:Black<CR>:w<CR>
imap <buffer> <leader>b <esc>:update<CR>:Black<CR>:w<CR>
nmap <buffer> <leader>i :update<CR>:Isort<CR>:w<CR>
imap <buffer> <leader>i <esc>:update<CR>:Isort<CR>:w<CR>

" line numbering
setlocal number " Turn on line numbering

