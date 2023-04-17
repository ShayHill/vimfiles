
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
nnoremap <buffer> <F5> :update<CR>:vert Make<CR>
inoremap <buffer> <F5> <esc>:update<CR>:vert Make<CR>

" run in integrated terminal
nnoremap <buffer> <F6> :update<CR>:ScratchTermReplaceU python %<CR>
inoremap <buffer> <F6> <esc>:update<CR>:ScratchTermReplaceU python %<CR>

" last :term pytest command, if any. No <CR>
nnoremap <buffer> <F7> :update<CR>:ScratchTermReplaceUV pytest<t_ku>
inoremap <buffer> <F7> <ESC>:update<CR>:ScratchTermReplaceUV pytest<t_ku>

setlocal colorcolumn=89
setlocal textwidth=85
setlocal formatoptions-=t  " do not autowrap text

" open files with all folds open. Should be just enough so that one zm will
" fold something. Will need to be tweaked as new folding code or plugins are
" used.
au filetype python setlocal foldlevel=3

" run Black and MyPy
nmap <buffer> <leader>b :update<CR>:ScratchTerm pre-commit run black --files %<CR>:update<CR>
imap <buffer> <leader>b <ESC>:update<CR>:ScratchTerm pre-commit run black --files %<CR>:update<CR>
nmap <buffer> <leader>i :update<CR>:ScratchTerm pre-commit run isort --files %<CR>:update<CR>
imap <buffer> <leader>i <ESC>:update<CR>:ScratchTerm pre-commit run isort --files %<CR>:update<CR>


