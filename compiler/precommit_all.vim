vim9script

CompilerSet makeprg=pre-commit\ run\ --all-files

# # mypy
CompilerSet errorformat=%f:%l:\ error:\ %m

# ruff
CompilerSet errorformat+=%.%#-->\ %f:%l:%c

# pyright
CompilerSet errorformat+=%f:%l:%c\ -\ error:\ %m
