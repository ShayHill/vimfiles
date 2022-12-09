syn region pythonComment
      \ start=+\%(:\n\s*\|\n\|^\)\@<=\z('''\|"""\)+ end=+\z1+ keepend
      \ contains=pythonEscape,pythonTodo,@Spell
