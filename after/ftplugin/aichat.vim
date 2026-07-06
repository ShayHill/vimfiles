vim9script

setlocal wrap
setlocal linebreak

# make window behave like ChatGPT, Discord, etc. Shift-Enter inserts a line.
# Enter submits a query.
nnoremap <buffer> <Enter> :AIChat<CR>
inoremap <buffer> <Enter> <Esc>:AIChat<CR>
nnoremap <buffer> <S-Enter> <Enter>
inoremap <buffer> <S-Enter> <Enter>

