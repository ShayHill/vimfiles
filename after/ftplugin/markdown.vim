" packadd vim-markdown
packadd markdown-preview.nvim


function! MarkdownLevel()
    if getline(v:lnum) =~ '^#.*$'
        return ">1"
    endif
    return "=" 
endfunction

au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr

setlocal wrap
setlocal linebreak
