vim9script

# nice defaults from Bram and the The Vim Project
source $VIMRUNTIME/defaults.vim

# ---------------------------------------------------------------------------- #
#
#  Vimspector Cheat Sheet
#
# Key          Mapping                                      Function
# F5           <Plug>VimspectorContinue                     When debugging, continue. Otherwise start debugging.
# F3           <Plug>VimspectorStop                         Stop debugging.
# F4           <Plug>VimspectorRestart                      Restart debugging with the same configuration.
# F6           <Plug>VimspectorPause                        Pause debuggee.
# F9           <Plug>VimspectorToggleBreakpoint             Toggle line breakpoint on the current line.
# <leader>F9   <Plug>VimspectorToggleConditionalBreakpoint  Toggle conditional line breakpoint or logpoint on the current line.
# F8           <Plug>VimspectorAddFunctionBreakpoint        Add a function breakpoint for the expression under cursor
# <leader>F8   <Plug>VimspectorRunToCursor                  Run to Cursor
# F10          <Plug>VimspectorStepOver                     Step Over
# F11          <Plug>VimspectorStepInto                     Step Into
# F12          <Plug>VimspectorStepOut                      Step out of current function scope
#
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
#
#   external programs
#
# ---------------------------------------------------------------------------- #

if has("windows")
	set shell=pwsh
	var local_programs = expand('$HOME/AppData/Local/Programs')
	execute 'set pythonthreehome=' .. local_programs .. "/Python/Python312"
	execute 'set pythonthreedll=' .. local_programs .. "/Python/Python312/python312.dll"
	execute 'set luadll=' .. local_programs .. '/Lua/bin/lua54.dll'

	if executable('rg')
		set grepprg=rg\ --vimgrep\ --no-heading\ --glob\ !binaries\ --glob\ !resources
	else
		echoerr "rg not found. Install ripgrep to use :grep"
	endif
endif


# ---------------------------------------------------------------------------- #
#
#   source other local config files
#
# ---------------------------------------------------------------------------- #

# source this before loading the plugins
source $MYVIMDIR/plugin_config.vim


# ---------------------------------------------------------------------------- #
#
#  colorscheme
#
#  Toggle between two preferred colorschemes to switch without distraction
#  when I'm on my laptop in certain lighting conditions.
#
# ---------------------------------------------------------------------------- #

def g:RestoreLspHighlights(): void
	highlight link LspErrorHighlight Error
	highlight link LspWarningHighlight Todo
	highlight link LspInformationHighlight Normal
	highlight link LspHintHighlight Normal
enddef

# Must set colorscheme before vim9-focalpoint defines an autogroup for the vim
# `colorscheme` command.

set t_Co=256 # enable 256 colors

g:gruvbox_italics = 0 # disable italic comments and keywords

var _dark_colorscheme = "habamax"
var _light_colorscheme = "PaperColor"

if !exists('g:colors_name')
	execute "colorscheme" _dark_colorscheme
	set background=dark
endif

var _toggle = 1


# set colorscheme if exists, else set fallback. If fallback does not exist,
# this will fail, so fallback should be a built-in colorscheme.
def TrySetColorscheme(colorscheme: string, fallback: string)
	try
		execute "colorscheme" colorscheme
	catch /^Vim\%((\a\+)\)\=:E185/
		execute "colorscheme" fallback
	endtry
enddef


# toggle between my two preferred colorschemes
# will default to dark when starting vim, but will leave light when sourcing
# vimrc if current colorscheme is set.
def g:ToggleColorScheme()
	_toggle = _toggle ? 0 : 1
	if _toggle == 1
		TrySetColorscheme(_dark_colorscheme, "habamax")
		set background=dark
	else
		TrySetColorscheme(_light_colorscheme, "default")
		set background=light
	endif
	call g:RestoreLspHighlights()
enddef

nnoremap <silent> <Leader>ll :call g:ToggleColorScheme()<CR>


# ---------------------------------------------------------------------------- #
#
#   package management
#
# ---------------------------------------------------------------------------- #

# load Vim internal plugins
packadd! matchit  # jump between html tags with %
packadd! comment  # (un)comment lines with gc, gcc
packadd! nohlsearch  # clear search highlighting after insert or timeout


def PackInit(): void
	packadd minpac

	minpac#init()
	minpac#add('k-takata/minpac', {'type': 'opt'})

	# -------- everything needed for lsp and completion
	minpac#add('prabirshrestha/vim-lsp')
	minpac#add('mattn/vim-lsp-settings')
	minpac#add('prabirshrestha/asyncomplete.vim')
	minpac#add('prabirshrestha/asyncomplete-lsp.vim')

	# -------- ai completion and chat
	minpac#add('github/copilot.vim')
	minpac#add('madox2/vim-ai', {do: '!py -m pip install "openai>=0.27"'})

	# -------- snippets
	minpac#add('SirVer/ultisnips')

	# -------- fuzzy finder
	minpac#add('Donaldttt/fuzzyy')

	# -------- the usual suspects
	minpac#add('tpope/vim-fugitive')  # git integration
	minpac#add('tpope/vim-obsession')  # session management
	minpac#add('tpope/vim-surround')  # surround text objects
	minpac#add('tpope/vim-vinegar')  # netrw enhancement
	minpac#add('tpope/vim-dispatch')  # async build
	minpac#add('airblade/vim-gitgutter')  # show git changes
	minpac#add('dyng/ctrlsf.vim')  # like :CocSearch

	# -------- markdown
	minpac#add('instant-markdown/vim-instant-markdown')  # requires node and curl

	# -------- colorschemes
	minpac#add('lifepillar/vim-solarized8')
	minpac#add('NLKNguyen/papercolor-theme')

	# -------- my plugins
	minpac#add('shayhill/vim9-scratchterm')
	minpac#add('shayhill/vim9-focalpoint')

	# -------- vimwiki
	# minpac#add('vimwiki/vimwiki')
enddef

command! PackUpdate source $MYVIMRC | PackInit() | minpac#update()
command! PackClean  source $MYVIMRC | PackInit() | minpac#clean()
command! PackStatus packadd minpac | minpac#status()


# ---------------------------------------------------------------------------- #
#
#  keep the working directory clean
#
# ---------------------------------------------------------------------------- #

set undofile  # undo changes even after closing vim
set backup  # write unsaved changes to a backup file

$TMPDIR = expand('~/AppData/Local/Temp/vim')

def MakeDirIfNoExists(path: string): void
	if !isdirectory(expand(path))
		call mkdir(expand(path), "p")
	endif
enddef

set backupdir=$TMPDIR/backup/
set undodir=$TMPDIR/undo/
set directory=$TMPDIR/swap/

silent! call MakeDirIfNoExists(&undodir)
silent! call MakeDirIfNoExists(&backupdir)
silent! call MakeDirIfNoExists(&directory)


# ---------------------------------------------------------------------------- #
#
#  behaviors
#
# ---------------------------------------------------------------------------- #

# source any local .vimrc file in the current directory (for project-specific
# Vim configuration)
set exrc

# opening files
set path+=**
set wildmode=list:longest,full

# aggresive autsave
set autowriteall  # Save when switching buffers

# Searching
match IncSearch '\s\+$' # automatically highlight trailing whitespace
set hlsearch # highlight search results
# T-pope mapping to un-highlight search results and call :diffupdate
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

# Vim Options
set synmaxcol=176 # speed up by only highlighting first 176 chars
set cursorline # highlight the line under the cursor
set noshowmode # showing modes in statusline, so no need for the status popup
set shortmess-=S # show match counts below statusline
set number # line numbers
set relativenumber # number lines relative to cursor
set autoread # read file changes without asking if no unsaved changes
set visualbell # flash instead of beeping for errors
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions-=t  # do not autowrap text


# ---------------------------------------------------------------------------- #
#
#  mappings
#
# ---------------------------------------------------------------------------- #

# switch windows
nnoremap <C-J> <C-w>w
nnoremap <C-K> <C-w>W
tnoremap <C-J> <C-\><C-n><C-w>w
tnoremap <C-K> <C-\><C-n><C-w>W

# <leader><leader>a (any letter) will navigates to the global bookmark A (any
# letter) then jumps to the last cursor position.
noremap <leader><leader> <cmd>exec "normal '" .. toupper(getcharstr()) .. "`\""<cr>

# remove trailing whitespace
nnoremap <leader>_ :%s/\s\+$//g<CR>

# save as root with :w!!
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>
cmap w!! w !Start-Process vim % > NUL<CR>:e!<CR><CR>

# print the date and time
if has("windows")
	nnoremap <leader>dt "=strftime("%y%m%d %H:%M:%S ")<CR>P
	inoremap <leader>dt <C-R>=strftime("%y%m%d %H:%M:%S ")<CR>
else
	nnoremap <leader>dt "=strftime("%y%m%d %T ")<CR>P
	inoremap <leader>dt <C-R>=strftime("%y%m%d %T ")<CR>
endif

# highlight all characters except ascii printable, \n, and \t. This is for
# finding unicode characters that are hard to see.
nnoremap <leader>np /[ -~\n\t_]\@!<CR>

# refresh highlighting.
map <Leader>h :syntax sync fromstart<CR>

# it's so easy to mistype :w that even my mech keyboard somehow occasionally
# does it with autoshift.
command! W w

# my 40% keyboard has no 6, only k6 (numpad 6), so the built in C-6 command
# won't work without this mapping.
map <C-k6> <C-6>


# ---------------------------------------------------------------------------- #
#
#  Search (and Replace) with code
#
#  to replace register a with register b
#  :s/<C-R>=CStr(@a)<CR>/<C-R>=CStrR(@b)<CR>/
#
# ---------------------------------------------------------------------------- #

def g:CStr(text: string): string
	# Command string. Escape any characters that might interfere with using a
	# string as a match. This is for use in search `/HERE` or the left
	# argument of search and replace `:s/HERE//`
	var escaped_string = text
	escaped_string = escape(escaped_string, '^$.*\/~[]')
	escaped_string = substitute(escaped_string, '\n', '\\n', 'g')
	return escaped_string
enddef

def g:CStrR(text: string): string
	# Command string Right or Command string Replace. Escape characters that
	# would interfere with using a string on the right `:s//HERE/` side of a
	# search and replace pattern.
	var escaped_string = text
	escaped_string = escape(escaped_string, '\/')
	escaped_string = substitute(escaped_string, '\n', '\r', 'g')
	return escaped_string
enddef

# ---------------------------------------------------------------------------- #
#
#  Statusline
#
#  This statusline configuration requires plugin vim9-focalpoint
#
# ---------------------------------------------------------------------------- #

# for debugging syntax highlighting
nnoremap <C-F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


set laststatus=2

g:line_mode_map = {
	"n": "N",
	"v": "V",
	"V": "V",
	"\<c-v>": "V",
	"i": "I",
	"R": "R",
	"r": "R",
	"Rv": "R",
	"c": "C",
	"s": "S",
	"S": "S",
	"\<c-s>": "S",
	"t": "T" }

g:use_pmenu_to_shade = [
	'delek',
	'habamax',
	'industry',
	'koehler',
	'lunaperche',
	'morning',
	'pablo',
	'peachpuff',
	'quiet',
	'retrobox',
	'torte',
	'wildcharm' ]

augroup ResetStatuslineHiGroups
	autocmd!
	autocmd colorscheme * g:focalpoint_use_pmenu = index(g:use_pmenu_to_shade, g:colors_name) != -1 ? v:true : v:false | g:FPReset()
augroup END

augroup ShadeNotCurrentWindow
	autocmd!
	autocmd WinEnter * setl wincolor=Normal
	autocmd WinLeave * setl wincolor=NormalNC
augroup END

def g:GenerateStatusline(winid: number): string
	var stl = ""

	# inline highlight group strings
	var bold_f = g:FPHiSelect(winid, 'StatusLineHard', 'StatusLineNCSoft', 'StatusLineCNHard')
	var weak = g:FPHiSelect(winid, 'StatusLineSoft', 'StatusLineNCSoft', 'StatusLineCNSoft')
	var weak_u = g:FPHiSelect(winid, 'StatusLine', 'StatusLineNCSoft', 'StatusLineCN')
	var bold_u = g:FPHiSelect(winid, 'StatusLine', 'StatusLineNCHard', 'StatusLineCN')
	var plain = g:FPHiSelect(winid, 'StatusLine', 'StatusLineNC', 'StatusLineCN')

	var sep = plain .. '|'

	# show current mode in bold
	stl ..= bold_f .. ' %{g:line_mode_map[mode()]} ' .. sep

	# show branch (requires fugitive)
	if exists('g:loaded_fugitive')
	 stl ..= weak_u .. ' %{FugitiveHead()} ' .. sep
	endif

	# relative file path
	stl ..= plain .. ' %f %M'
	# empty space to right-anchor remaining items
	stl ..= '%='

	# line and column numbers
	stl ..= plain .. ' %l' .. ':' .. '%L' .. ' ☰ ' .. '%c '
	stl ..= sep

	# buffer number
	stl ..= weak .. ' b' .. bold_u .. '%n'

	# window number
	stl ..= weak .. ' w' .. bold_u .. '%{win_getid()} '
	return stl
enddef

set statusline=%!GenerateStatusline(g:statusline_winid)
