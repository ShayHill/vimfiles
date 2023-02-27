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

CompilerSet makeprg=pre-commit\ run\ ruff\ --files
CompilerSet errorformat=%f:%l:%c:\ %m
