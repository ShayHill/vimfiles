vim9script

# Define a command, ScratchTerm, that creates a new terminal buffer and marks
# it as a scratch buffer. This allows us to kill all scratch terminals in the
# current view with a single function.


# -----------------------------------------------------------------------------#
#
#  Identify scratch terminals 
#
# ---------------------------------------------------------------------------- #

def IsScratchTerm(bufnr: number): bool
    # Return 1 if the buffer was created with the ScratchTerm command,
    # 0 otherwise.
    if bufexists(bufnr) && getbufvar(bufnr, 'scratch_term', 0)
        return v:true
    endif
    return v:false
enddef


def HasBufferWindow(bufnr: number): bool
    # Return 1 if the buffer has a current window
    var windows = getbufinfo(bufnr)[0].windows
    for winid in windows
        if win_id2win(winid) != -1
            return v:true
        endif
    endfor
    return v:false
enddef


def IsBufferOnCurrentTab(bufnr: number): bool
    # Return 1 if the buffer is visible in the current tab, 0 otherwise.
    var windows = getbufinfo(bufnr)[0].windows
    for winid in windows
        if tabpagenr() == win_id2tabwin(winid)[0]
            return v:true
        endif
    endfor
    return v:false
enddef


def IsVisibleScratchTerm(bufnr: number): bool
    # Return 1 if the buffer is visible in the current view, 0 otherwise.
    return IsScratchTerm(bufnr) && HasBufferWindow(bufnr) && IsBufferOnCurrentTab(bufnr)
enddef


# -----------------------------------------------------------------------------#
#
#  Open remote scratch terminals
#
# ---------------------------------------------------------------------------- #


def RemoteScratchTermFunc(...args: list<string>): void
    # Run a command in a scratch terminal. Keep focus.
    var prev_winid = win_getid()
    execute 'ScratchTerm ' .. join(args, ' ')
    call win_gotoid(prev_winid)
enddef


def VRemoteScratchTermFunc(...args: list<string>): void
    # Run a command in a scratch terminal. Keep focus.
    var prev_winid = win_getid()
    execute 'VScratchTerm ' .. join(args, ' ')
    call win_gotoid(prev_winid)
enddef


# -----------------------------------------------------------------------------#
#
#  Close or kill scratch terminals
#
# ---------------------------------------------------------------------------- #


def CloseOrKillScratchTerms(do_kill: bool): void
    # Close or kill all terminals in the current view that were opened with
    # the ScratchTerm command. If you can see a terminal created with
    # ScratchTerm, this will kill it.
    var scratch_terms = range(1, bufnr('$')) -> filter((_, v) => IsVisibleScratchTerm(v))

    for term in scratch_terms
        if do_kill
            execute 'bdelete! ' .. term
        else
            execute 'bdelete ' .. term
        endif
    endfor
enddef


# -----------------------------------------------------------------------------#
#
#  Commands
#
# ---------------------------------------------------------------------------- #


# open a horizontal or vertical scratch terminal. focus on terminal
command! -nargs=* -complete=file ScratchTerm execute 'term <args>' | b:scratch_term = 1
command! -nargs=* -complete=file VScratchTerm execute 'vert term <args>' | b:scratch_term = 1

# open a horizontal or vertical scratch terminal. focus on present window
command! -nargs=* -complete=file RemoteScratchTerm call RemoteScratchTermFunc(<f-args>)
command! -nargs=* -complete=file VRemoteScratchTerm call VRemoteScratchTermFunc(<f-args>)

# kill or close all scratch terminals in the current view
command! KillScratchTerms call CloseOrKillScratchTerms(v:true)
command! CloseScratchTerms call CloseOrKillScratchTerms(v:false)
