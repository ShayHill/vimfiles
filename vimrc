vim9script

# don't make Vim pretend to be Vi
set nocompatible
syntax on


# I prefer comma as a leader key, because it is always followed by a space in
# sane typing and Python programming.
g:mapleader = ','  # for <leader> shortcuts.


# remove "You discovered the command-line window!" message from defaults.vim.
augroup vimHints | exe 'au!' | augroup END


# ---------------------------------------------------------------------------- #
#
#  colorscheme
#
# ---------------------------------------------------------------------------- #


# Must set colorscheme before vim9-focalpoint defines an autogroup for the vim
# `colorscheme` command.

set t_Co=256 # enable 256 colors

g:gruvbox_italics = 0 # disable italic comments and keywords

var _dark_colorscheme = "habamax"
var _light_colorscheme = "PaperColor"

var _toggle = 1
if g:colors_name == _light_colorscheme
    _toggle = 0
endif


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
# vimrc if current colorscheme is light.
def g:ToggleColorScheme()
    _toggle = _toggle ? 0 : 1
    if _toggle == 1
        TrySetColorscheme(_dark_colorscheme, "habamax")
        set background=dark
    else
        TrySetColorscheme(_light_colorscheme, "default")
        set background=light
    endif
enddef

noremap <silent> <Leader>ll :call g:ToggleColorScheme()<CR>

# ---------------------------------------------------------------------------- #
#
# set up Python and other Windows options
#
# ---------------------------------------------------------------------------- #

if has("windows")
	set shell=pwsh
	set pythonthreehome=C:\\Users\\shaya\\AppData\\Local\\Programs\\Python\\Python312
	set pythonthreedll=C:\\Users\\shaya\\AppData\\Local\\Programs\\Python\\Python312\\python312.dll

	# Use ripgrep in :grep if installed. The vim default for Windows
	# (works in cmd) will freeze Powershell.
	if executable("rg")
		set grepprg=rg\ --vimgrep\ --no-heading
	else
		echoerr "rg not found. Install ripgrep to use :grep"
	endif
endif


# ---------------------------------------------------------------------------- #
#
# source external config files
#
# ---------------------------------------------------------------------------- #

# this is just a path variable to use later 
if has('windows')
    $VIMFILES = "~/vimfiles"
else
    $VIMFILES = "~/.vim"
endif

if has('gui_running')
    source $VIMFILES/gvim.vimrc
else
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

# this has to be sourced before loading the plugins
source $VIMFILES/plugin_config.vim


# ---------------------------------------------------------------------------- #
#
#  minpac
#
# ---------------------------------------------------------------------------- #

def PackInit(): void
    packadd minpac
    call minpac#init()
    minpac#add('k-takata/minpac', {'type': 'opt'})

    # -------- everything needed for lsp and completion
    minpac#add('prabirshrestha/vim-lsp')
    minpac#add('mattn/vim-lsp-settings')
    minpac#add('prabirshrestha/asyncomplete.vim')
    minpac#add('prabirshrestha/asyncomplete-lsp.vim')
    # -------- AI
    minpac#add('github/copilot.vim')
    minpac#add('madox2/vim-ai', {do: '!python -m pip install "openai>=0.27"'})
    # -------- snippets
    minpac#add('SirVer/ultisnips')
    # -------- the usual suspects
    minpac#add('tpope/vim-fugitive')  # git integration
    minpac#add('tpope/vim-obsession')  # session management
    minpac#add('tpope/vim-commentary')  # commenting
    minpac#add('tpope/vim-vinegar')  # netrw enhancement
    minpac#add('tpope/vim-surround')  # surround text objects
    minpac#add('tpope/vim-dispatch')  # async build
    minpac#add('puremourning/vimspector')
    # -------- nice to haves
    minpac#add('airblade/vim-gitgutter')  # show git changes
    minpac#add('dyng/ctrlsf.vim')  # like :CocSearch
    # -------- markdown
    minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! | call mkdp#util#install()'})  # requires nodejs
    # -------- low-star projects that seem to work OK
    minpac#add('monkoose/vim9-stargate')  # easymotion
    minpac#add('BourgeoisBear/clrzr')  # colorize hex codes
    # -------- colorschemes
    minpac#add('lifepillar/vim-solarized8')
    minpac#add('NLKNguyen/papercolor-theme')
    # -------- my plugins
    minpac#add('shayhill/vim9-scratchterm')
    minpac#add('shayhill/vim9-focalpoint')
    # -------- trying out
    minpac#add('Donaldttt/fuzzyy')
enddef

command! PackUpdate PackInit() | minpac#update() | source $VIMFILES/plugin_config.vim
command! PackClean  PackInit() | minpac#clean() | source $VIMFILES/plugin_config.vim
command! PackStatus packadd minpac | minpac#status()


# ---------------------------------------------------------------------------- #
#
#  Vimspector
#
# ---------------------------------------------------------------------------- #

g:vimspector_enable_mappings = 'HUMAN'

nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval

nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame
nmap <LocalLeader>B     <Plug>VimspectorBreakpoints
nmap <LocalLeader>D     <Plug>VimspectorDisassemble





# ---------------------------------------------------------------------------- #
#
#  keep the working directory clean
#
# ---------------------------------------------------------------------------- #

$TMPDIR = expand("~/tmp/vim")

def MakeDirIfNoExists(path: string): void
	if !isdirectory(expand(path))
		call mkdir(expand(path), "p")
	endif
enddef

set undofile  # undo changes even after closing vim
set backup  # write unsaved changes to a backup file
set noswapfile  # do not create swapfiles

set backupdir=$TMPDIR/backup/
set undodir=$TMPDIR/undo/
set directory=$TMPDIR/swap/
set viminfo+=n$TMPDIR/viminfo

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

# do not save options in sessions, only windows and buffers
# set sessionoptions-=options

# opening files
set path+=**
set wildmenu
# set wildignore+=*/__pycache__/*,*/venv/*,*/dist/*,*/.tox/*,*.docx,*/binaries/*,*/.cache/*
set wildmode=list:longest,full


# aggresive autsave
set autowriteall  # Save when switching buffers
# set hidden # allow switching buffers w/o saving.


# Searching
match IncSearch '\s\+$' # automatically highlight trailing whitespace
set incsearch # start searching as soon as you start to type /...
set hlsearch # highlight search results
# T-pope mapping to un-highlight search results and call :diffupdate
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>


# Indentation
set expandtab # spaces instead of tabs
set tabstop=4 # a tab = four spaces
set shiftwidth=4 # number of spaces for auto-indent
set softtabstop=4 # a soft-tab of four spaces
set autoindent # turn on auto-indent


# scrolloff
set scrolloff=1
set sidescroll=1
set sidescrolloff=2


# Vim Options
set synmaxcol=176 # speed up by only highlighting first 176 chars
set cursorline # highlight the line under the cursor
set showcmd # shows partial commands beneath statusline
set noshowmode # showing modes in statusline, so no need for the status popup
set shortmess-=S # show match counts below statusline
set splitright # open vertical splits on the right
set number # line numbers
set relativenumber # number lines relative to cursor
set autoread # read file changes without asking if no unsaved changes
set backspace=indent,eol,start # normal backspace behavior of other applications
set nrformats-=octal # don't interpret 011 as 9
set visualbell # flash instead of beeping for errors



# ---------------------------------------------------------------------------- #
#
#  mappings
#
# ---------------------------------------------------------------------------- #

# save with C-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

# <F3>, <F4>, and <F8> mapped if HasPlugin scratch_term
# <F5>, <F6>, and <F7> reserved for filetype-specific mappings
# <F11> gvim fullscreen
# <F12> gvim translucent

# fuzzy-finder muscle memory
nnoremap <C-P> :FuzzyGitFiles<CR>
inoremap <C-P> <ESC>:FuzzyGitFiles<CR>
# cnoremap <C-T> <HOME> tabnew \| <END><CR>
# cnoremap <C-X> <HOME> split \| <END><CR>
# cnoremap <C-V> <HOME> vsplit \| <END><CR>

# switch windows
nnoremap <C-J> <C-w>w
nnoremap <C-K> <C-w>W
tnoremap <C-J> <C-\><C-n><C-w>w
tnoremap <C-K> <C-\><C-n><C-w>W

# <leader><leader>a (any letter) will navigates to the global bookmark A (any
# letter) then jumps to the last cursor position.
noremap <leader><leader> <cmd>exec "normal '" .. toupper(getcharstr()) .. "`\""<cr>

# it's so easy to mistype :w that even my mech keyboard somehow does it
# with autoshift.
command! W w

# enter terminal normal mode with <leader>n
tnoremap <leader>n <C-w>N

# remove trailing whitespace
nnoremap <leader>_ :%s/\s\+$//g<CR>

# # clear search highlights with space.
# nnoremap <space> :noh<CR>

# save as root with :w!!
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

# print the date and time
if has("win32")
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





                                        

# # navigate command history without arrow keys
# cnoremap <C-j> <t_kd>
# cnoremap <C-k> <t_ku>
# cnoremap <C-h> <t_kl>
# cnoremap <C-l> <t_kr>


# ---------------------------------------------------------------------------- #
#
#  Deal with buffers
#
# ---------------------------------------------------------------------------- #

# naturally, these only work in gvim
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

# keep rolling if you shift-tab into the integrated terminal
tmap <C-Tab> <C-w>:bnext<cr>
tmap <C-S-Tab> <C-w>:bprevious<cr>

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
# ---------------------------------------------------------------------------- #

# for debugging syntax highlighting
# nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
# \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
# \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


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

augroup markdownformat
  autocmd!
  autocmd FileType markdown setlocal formatprg=pandoc\ -t\ commonmark_x
  autocmd FileType markdown setlocal equalprg=pandoc\ -t\ commonmark_x
augroup END

