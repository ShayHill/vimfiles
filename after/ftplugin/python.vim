vim9script

setlocal expandtab  # spaces instead of tabs
setlocal tabstop=4  # a tab = four spaces
setlocal shiftwidth=4  # number of spaces for auto-indent
setlocal softtabstop=4  # a soft-tab of four spaces
setlocal autoindent  # turn on auto-indent

setlocal colorcolumn=89  # max cols in black is 88
setlocal textwidth=85  # wrapping for gq

setlocal nowrap

if g:HasPlugin('coverage-highlight.vim')
  packadd coverage-highlight.vim
  nnoremap <buffer> <leader>c :HighlightCoverage<CR>
  nnoremap <buffer> <leader>C :HighlightCoverageOff<CR>
  nnoremap <buffer> <leader>ct :ToggleCoverage<CR>
  nnoremap <buffer> <leader>cn :NextUncovered<CR>
  nnoremap <buffer> <leader>cp :PrevUncovered<CR>
endif

# ---------------------------------------------------------------------------- #
#
#  build commands as strings to run formatters
#
# ---------------------------------------------------------------------------- #


def g:RunPrecommit(): void
  compiler precommit
  update
  vert Make
enddef


def g:RunPrecommitAll(): void
  compiler precommit_all
  update
  vert Make
enddef


if executable('pre-commit') && g:HasPlugin("vim-dispatch")
  compiler precommit
  nmap <buffer> <leader>l :call RunPrecommit()<CR>
  nmap <buffer> <leader>L :call RunPrecommitAll()<CR>
endif


def MarkAndReturn(cmd: string): string
  # Mark `, run command, return to mark.
  # Keeps commands like black that jump around from moving the cursor.
  return 'm`' .. cmd .. '``'
enddef


def UpdateAround(cmd: string): string
  # Update buffer, run command, update buffer.
  return ':update<CR>' .. cmd .. ':update<CR>'
enddef


def MapBlackIfFound(): void
  if g:HasPlugin('lsp')
    execute 'nmap <buffer> <leader>b :LspFormat<CR>'
    return
  endif
  if executable('black')
    var cmd = UpdateAround(MarkAndReturn(':!black % -q<CR>'))
    execute 'nmap <buffer> <leader>b ' .. cmd
    return
  endif
  execute 'nmap <buffer> <leader>b :echo "no formatter found"<CR>'
enddef


def MapIsortIfFound(): void
  if g:HasPlugin('lsp')
    execute 'nmap <buffer> <leader>i :LspOrganizeImports<CR>'
    return
  endif
  if executable('isort')
    var cmd = UpdateAround(MarkAndReturn(':!isort % -q<CR>'))
    execute 'nmap <buffer> <leader>i ' .. cmd
    return
  endif
  execute 'nmap <buffer> <leader>i :echo "isort not found"<CR>'
enddef


def MapAutoflakeIfFound(): void
  var af_cmd = ':!autoflake --in-place --remove-all-unused-imports %<CR>'
  if executable('autoflake')
    var cmd = UpdateAround(MarkAndReturn(af_cmd))
    execute 'nmap <buffer> <leader>ii ' .. cmd
    return
  endif
  execute 'nmap <buffer> <leader>ii :echo "no autoflake found"<CR>'
enddef


MapBlackIfFound()
MapIsortIfFound()
MapAutoflakeIfFound()


# ---------------------------------------------------------------------------- #
#
#  run Python or Pytest in a terminal
#
# ---------------------------------------------------------------------------- #


def! g:LoadCommand(cmd: string)
  # Write a command onto the command line.
  # Do not execute it.
  # The command argument is a string that starts with a colon.
  update
  feedkeys(cmd, "n")
  sleep 100m
  call feedkeys("\<Up>", 'nt')
enddef


if g:HasPlugin("vim9-scratchterm")
  # execute Python or Pytest in scratch terminals
  nmap <buffer> <leader>e :update<CR>:ScratchTermReplaceU python %<CR>

  # last :term pytest command, if any. No <CR>
  g:pt_cmd = ':ScratchTermReplaceUV python -m pytest'
  nmap <buffer> <leader>t :call g:LoadCommand(g:pt_cmd)<CR>
  nmap <buffer> <leader>T :call g:LoadCommand(g:pt_cmd .. ' ' .. expand('%'))<CR>
else
  g:py_cmd = ':term ' .. python .. ' % <CR>'
  nmap <buffer> <leader>e :update<CR>:term python %<CR>

  # last :term pytest command, if any. No <CR>
  g:pt_cmd = ':vert term python -m pytest'
  nmap <buffer> <leader>t :call g:LoadCommand(g:pt_cmd)<CR>
endif


