vim9script

CompilerSet makeprg=pre-commit\ run\ -a

# errorformats:
# 1. ruff
# 2. mypy
# 3. pyright
CompilerSet errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%f:%l:%c\ -\ %m,%f:
