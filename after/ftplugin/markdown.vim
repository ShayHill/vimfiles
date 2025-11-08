
function! MarkdownLevel()
  if getline(v:lnum) =~ '^#.*$'
    return ">1"
  endif
  return "="
endfunction

setlocal foldexpr=MarkdownLevel()
setlocal foldmethod=expr

setlocal wrap
setlocal linebreak

def SmartQuotes(): void
  silent! execute(':%s/^"/“/')
  silent! execute(':%s/\(\s\)"/\1“/g')
  silent! execute(':%s/"/”/g')
  silent! execute(":%s/^'/‘/")
  silent! execute(":%s/\(\s\)'/\1‘/g")
  silent! execute(":%s/'/’/g")
enddef

def DumbQuotes(): void
  silent! execute(':%s/“/"/g')
  silent! execute(':%s/”/"/g')
  silent! execute(":%s/‘/'/g")
  silent! execute(":%s/’/'/g")
enddef

nnoremap <leader>q :call SmartQuotes()<CR>
nnoremap <leader>Q :call DumbQuotes()<CR>
