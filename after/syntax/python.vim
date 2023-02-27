" Color python docstrings as \# comments, not as triple-quoted text.

syn region pythonComment
      \ start=+\%(:\n\s*\|\n\|^\)\@<=\z('''\|"""\)+ end=+\z1+ keepend
      \ contains=pythonEscape,pythonTodo,@Spell

syn region pythonComment
      \ start=+\%(:\n\s*\|\n\|^\)\@<=[rR]\z('''\|"""\)+ end=+\z1+ keepend
      \ contains=pythonEscape,pythonTodo,@Spell
