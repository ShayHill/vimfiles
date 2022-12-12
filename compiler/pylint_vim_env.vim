" Vim compiler file
" Compiler:	Pylint for Python
" Maintainer: Daniel Moch <daniel@danielmoch.com>
" Last Change: 2016 May 20
" Updated 221202 12:26:43 by Shay Hill. Altered makeprg to use a pylint in my
" vim-env Python environment.

if exists("current_compiler")
  finish
endif
let current_compiler = "pylint_vim_env"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

if has('win32')
    CompilerSet makeprg=~/vimfiles/vim-env/Scripts/pylint --output-format=text\ --msg-template=\"{path}:{line}:{column}:{C}:\ [{symbol}]\ {msg}\"\ --reports=no
else
    CompilerSet makeprg=~/.vim/vim-env/bin/pylint --output-format=text\ 
endif
CompilerSet errorformat=%A%f:%l:%c:%t:\ %m,%A%f:%l:\ %m,%A%f:(%l):\ %m,%-Z%p^%.%#,%-G%.%#
