vim9script

CompilerSet makeprg=pre-commit\ run\ --all-files

# errorformat
# ruff: %E\ \ \ -->\ %f:%l:%c
# ruff: %E\ \ -->\ %f:%l:%c,%E%f:%l:\ %m
# ruff: %E%f:%l:%c:\ %m
# mypy: %E%f:%l:\ %m
# pyright: %E\ \ %f:%l:%c\ -\ %m

CompilerSet errorformat=%E\ \ \ -->\ %f:%l:%c,%E\ \ -->\ %f:%l:%c,%E%f:%l:%c:\ %m,%E%f:%l:\ %m,%E\ %f:%l:%c\ -\ %m
