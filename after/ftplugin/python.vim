vim9script

setlocal expandtab  # spaces instead of tabs
setlocal tabstop=4  # a tab = four spaces
setlocal shiftwidth=4  # number of spaces for auto-indent
setlocal softtabstop=4  # a soft-tab of four spaces
setlocal autoindent  # turn on auto-indent

setlocal colorcolumn=89  # max cols in black is 88
setlocal textwidth=85  # wrapping for gq
setlocal formatoptions-=t  # do not autowrap text

setlocal nowrap


# ---------------------------------------------------------------------------- #
#
#  build commands as strings to run formatters
#
# ---------------------------------------------------------------------------- #
 
def FindModule(module: string): string
	# Find a module in a local venv. Failing that search for
    # module in vimthreehome. Return the path to the module
    # or 'false' if not found.
	var venv_python = './venv/Scripts/' .. module
	if executable(venv_python)
		return venv_python
	endif
	var global_python = &pythonthreehome .. '/Scripts/' .. module
	if executable(global_python)
		return global_python
	endif
	return 'false'
enddef


var precommit = FindModule('pre-commit')
if executable(precommit)
	compiler precommit_vim_env
	nmap <buffer> <leader>l :update<CR>:vert Make<CR>:update<CR>
	imap <buffer> <leader>l <ESC>:update<CR>:vert Make<CR>:update<CR>
else
	echo "pre-commit not found"
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
    var black = FindModule('black')
    var cmd = UpdateAround(MarkAndReturn(':%!' .. black .. ' - -q<CR>'))
    if executable(black)
        execute 'nmap <buffer> <leader>b ' .. cmd
    else
        echo "black not found"
    endif
enddef


def MapIsortIfFound(): void
    var isort = FindModule('isort')
    var cmd = UpdateAround(MarkAndReturn(':%!' .. isort .. ' - -q<CR>'))
    if executable(isort)
        execute 'nmap <buffer> <leader>i ' .. cmd
    else
        echo "isort not found"
    endif
enddef


def MapAutoflakeIfFound(): void
    var autoflake = FindModule('autoflake')
    var af_cmd = ':%!' .. autoflake .. ' --in-place --remove-all-unused-imports -<CR>'
    var cmd = UpdateAround(MarkAndReturn(af_cmd))
    if executable(autoflake)
        execute 'nmap <buffer> <leader>ii ' .. cmd
    else
        echo "autoflake not found"
    endif
enddef


MapBlackIfFound()
MapIsortIfFound()
MapAutoflakeIfFound()


# ---------------------------------------------------------------------------- #
#
#  run Python or Pytest in a terminal
#
# ---------------------------------------------------------------------------- #

def FindPython(): string
	# Find the Python executable in the global python environment or in the venv.
	# Returns the path to the Python executable or 'false' if not found.
	if executable("venv/Scripts/python.exe")
		return 'python'
	else
		return 'py'
	endif
enddef


def g:LoadCommand(cmd: string)
	# Write a command onto the command line.
	# Do not execute it.
	# The command argument is a string that starts with a colon.
	update
	feedkeys(cmd, "n")
	sleep 100m
	call feedkeys("\<Up>", 'nt')
enddef


var python_binary = FindPython()
if g:HasPlugin("vim9-scratchterm")
	# execute Python or Pytest in scratch terminals
	var py_cmd = ':ScratchTermReplaceU ' .. python_binary .. ' %<CR>'
	nmap <buffer> <leader>e :update<CR>:execute py_cmd
	imap <buffer> <leader>e <ESC>:update<CR>:execute py_cmd

	# last :term pytest command, if any. No <CR>
	g:pt_cmd = ':ScratchTermReplaceUV ' .. python_binary .. ' -m pytest'
	nmap <buffer> <leader>t :call g:LoadCommand(g:pt_cmd)<CR>
	imap <buffer> <leader>t <ESC>:call g:LoadCommand(g:pt_cmd)<CR>
else
	var py_cmd = ':term ' .. python_binary .. ' %<CR>'
	nmap <buffer> <leader>e :update<CR>:execute py_cmd
	imap <buffer> <leader>e <ESC>:update<CR>:execute py_cmd

	# last :term pytest command, if any. No <CR>
	g:pt_cmd = ':vert term ' .. python_binary .. ' -m pytest'
	nmap <buffer> <leader>t :call g:LoadCommand(g:pt_cmd)<CR>
	imap <buffer> <leader>t <ESC>:call g:LoadCommand(g:pt_cmd)<CR>
endif

