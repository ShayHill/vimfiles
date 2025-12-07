vim9script

CompilerSet makeprg=pre-commit\ run

# mypy
CompilerSet errorformat=%f:%l:\ %m

# ruff
CompilerSet errorformat+=%E%m\ %#-->\ %f:%l:%c

# pyright
CompilerSet errorformat+=%f:%l:%c\ -\ %m

