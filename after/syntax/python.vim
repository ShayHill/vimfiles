" Color python triple-quoted docstrings as \# comments, not as strings.
" Triple-quoted strings in code (not after a colon and not starting at the
" beginning of a line) will still be highlighted as strings.

syn region pythonComment
      \ start=+\%(:\n\s*\|\n\|^\)\@<=[rR]\{0,1}\z('''\|"""\)+ end=+\z1+ keepend
      \ contains=pythonEscape,pythonTodo,@Spell


