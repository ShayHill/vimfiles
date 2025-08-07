
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
