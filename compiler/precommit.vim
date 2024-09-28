" Vim compiler file

let current_compiler = "precommit"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pre-commit\ run\ -a

" errorformats:
" 1. ruff
" 2. mypy
" 3. pyright
CompilerSet errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%f:%l:%c\ -\ %m,%f:
