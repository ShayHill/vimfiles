vim9script
# Plugin config is in ~/vimfiles/plugin_config.vim

# set by vim-sensible
# filetype plugin on # Indent and plugins by filetype
# set scrolloff=5 # screen space around cursor
# set sidescrolloff=5 # screen space around cursor
# set wildmenu  # Command line autocompletion

g:mapleader = ','  # for <leader> shortcuts.
set encoding=utf-8 # setup the encoding to UTF-8
scriptencoding utf-8 # Encoding for this script (to allow Unicode characters)

if has('win32')
    $VIMFILES = "~/vimfiles"
else
    $VIMFILES = "~/.vim"
endif

if has("win32")
    source $VIMRUNTIME\..\_vimrc # will contain some diff / Windows nuance
    # pwsh (Powershell 7+) breaks plenty of things, so disable it to debug
    # :make etc. Lowercase :make won't work with pwsh, at least not without
    # some obscure configuration I haven't found yet, but tpope/dispatch :Make
    # works fine.
	set shell=pwsh
	# interpreter for Python plugins
    set pythonthreehome=C:\Users\shaya\AppData\Local\Programs\Python\Python310-32
    set pythonthreedll=C:\Users\shaya\AppData\Local\Programs\Python\Python310-32\python310.dll
endif

# ---------------------------------------------------------------------------- #
#
#  other config files
#
# ---------------------------------------------------------------------------- #

if has('gui_running')
	source $VIMFILES/gvim.vimrc
endif


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

    # everything needed for lsp and completion
    minpac#add('prabirshrestha/vim-lsp')
    minpac#add('mattn/vim-lsp-settings')
    minpac#add('prabirshrestha/asyncomplete.vim')
    minpac#add('prabirshrestha/asyncomplete-lsp.vim')
    # AI
    minpac#add('github/copilot.vim')
    minpac#add('madox2/vim-ai')
    # snippets
    minpac#add('SirVer/ultisnips')
    # the usual suspects
    minpac#add('vim-airline/vim-airline')
    minpac#add('vim-airline/vim-airline-themes')
    minpac#add('tpope/vim-fugitive')  # git integration
    minpac#add('tpope/vim-sensible')  # sensible defaults
    minpac#add('tpope/vim-obsession')  # session management
    minpac#add('tpope/vim-commentary')  # commenting
    minpac#add('tpope/vim-vinegar')  # netrw enhancement
    minpac#add('tpope/vim-surround')  # surround text objects
    # nice to haves
    minpac#add('jremmen/vim-ripgrep')  # needs installed ripgrep
    minpac#add('airblade/vim-gitgutter')  # show git changes
    minpac#add('dyng/ctrlsf.vim')  # like :CocSearch
    # dispatch's :Make works sometimes when :make won't for PowerShell
    minpac#add('tpope/vim-dispatch')  # async build
    # fuzzy finding
    minpac#add('junegunn/fzf')
    minpac#add('junegunn/fzf.vim')
    # markdown
    minpac#add('preservim/vim-markdown')  # folding and syntax
    minpac#add('iamcco/markdown-preview.nvim')  # requires nodejs
    # low-star projects that seem to work OK
    minpac#add('moll/vim-bbye')  # close a buffer without closing the window
    minpac#add('monkoose/vim9-stargate')  # easymotion
    # Python
    minpac#add('tmhedberg/SimpylFold', {'type': 'opt'})  # folding
    # colorschemes
    minpac#add('lifepillar/vim-solarized8')
    minpac#add('lifepillar/vim-gruvbox8')
    minpac#add('NLKNguyen/papercolor-theme')
    minpac#add('cocopon/iceberg.vim')
    minpac#add('arcticicestudio/nord-vim')
    # my plugins
    minpac#add('shayhill/vim9-scratchterm')
enddef


# Define user commands for updating/cleaning the plugins.
# Each of them calls PackInit() to load minpac and register
# the information of plugins, then performs the task.
command! PackUpdate PackInit() | minpac#update() | source $VIMFILES/plugin_config.vim
command! PackClean  PackInit() | minpac#clean() | source $VIMFILES/plugin_config.vim
command! PackStatus packadd minpac | minpac#status()



# ---------------------------------------------------------------------------- #
#
#  colorscheme
#
# ---------------------------------------------------------------------------- #

set t_Co=256 # 256 colors for the terminal

g:gruvbox_italics = 0 # disable italic comments and keywords
try
    colorscheme iceberg
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme habamax
endtry

set background=dark # set a dark background


# ---------------------------------------------------------------------------- #
#
#  behaviors
#
# ---------------------------------------------------------------------------- #

# Keep The Working Directory Clean
def MakeDirIfNoExists(path: string): void
    if !isdirectory(expand(a:path))
	    call mkdir(expand(a:path), "p")
    endif
enddef
# set history=1000
set undofile
set undoreload=1000
set backup
set noswapfile
set backupdir=$HOME/tmp/vim/backup/
set undodir=$HOME/tmp/vim/undo/
set directory=$HOME/tmp/vim/swap/
set viminfo+=n$HOME/tmp/vim/viminfo
silent! call MakeDirIfNoExists(&undodir)
silent! call MakeDirIfNoExists(&backupdir)
silent! call MakeDirIfNoExists(&directory)

# Save When Switching Buffers
set autowrite
set autowriteall
#set hidden # switch buffers w/o saving. here to reming me if I unset

# Common Preference Settings
set foldlevel=99  # open all folds by default
match IncSearch '\s\+$'  # highlight trailing whitespace
set splitright # open vertical splits on the right
set number # line numbers

# Searching
set hlsearch # highlight search results
set ignorecase # ignore case when searching
set smartcase # override ignorecase if search pattern contains upper case

# Indentation
set expandtab # spaces instead of tabs
set tabstop=4 # a tab = four spaces
set shiftwidth=4 # number of spaces for auto-indent
set softtabstop=4 # a soft-tab of four spaces
set autoindent # turn on auto-indent

# Intuitive File Opening
set wildmode=list:longest,full  # Shows all the options

# Vim Options
set synmaxcol=176 # speed up by only highlighting first 176 chars
set cursorline # highlight the line under the cursor
set ttyfast # better screen redraw
set showcmd # shows partial commands
set nowrap # Turn off line wrapping
set noerrorbells # Turn off error bell - still rings for escape in normal mode
# set visualbell # turn on the visual bell


# ---------------------------------------------------------------------------- #
#
#  mappings
#
# ---------------------------------------------------------------------------- #


# vertical split to netrw
nmap <F2> :Vex<CR>
imap <F2> <esc>:Vex<CR>

# <F3>, <F4>, and <F8> mapped if HasPlugin scratch_term
# <F5>, <F6>, and <F7> reserved for filetype-specific mappings
# <F9> defined below for replace text under cursor
# <F11> gvim fullscreen
# <F12> gvim translucent

# switch windows
nnoremap <C-J> <C-w>w
nnoremap <C-K> <C-w>W

# return to last position in a globally bookmarked file. E.g, <leader>`A will
# return to the last position in bookmarked buffer A. `A without leader will
# return  to the cursor position when file A was bookmarked.
noremap <leader>' <cmd>exec "normal '".getcharstr()."`\""<cr>

# it's so easy to mistype :w that even my mech keyboard somehow does it
# with autoshift.
command! W w

# enter terminal normal mode with <leader>n
tnoremap <leader>n <C-w>N

# remove trailing whitespace
nnoremap <leader>_ :%s/\s\+$//g<CR>

# clear search highlights with space.
nnoremap <space> :noh<CR>

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

# refresh highlighting
map <Leader>h :syntax sync fromstart<CR>

# avoid arrow keys
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-h> <t_kl>
cnoremap <C-l> <t_kr>
# inoremap <C-j> <t_kd>
# inoremap <C-k> <t_ku>
# inoremap <C-h> <t_kl>
# inoremap <C-l> <t_kr>
# nnoremap <C-j> <t_kd>
# nnoremap <C-k> <t_ku>
# nnoremap <C-h> <t_kl>
# nnoremap <C-l> <t_kr>
# tnoremap <C-j> <t_kd>
# tnoremap <C-k> <t_ku>
# tnoremap <C-h> <t_kl>
# tnoremap <C-l> <t_kr>

# ---------------------------------------------------------------------- Buffers:
# ---------------------------------------------------------------------- Buffers:

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
#  F9 to replace text under cursor, even with special characters
#  https://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text/6171215#6171215
#
# ---------------------------------------------------------------------------- #

# Escape special characters in a string for exact matching.
# This is useful to copying strings from the file to the search tool
# Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
def EscapeString(my_string: string): string
    var string = my_string
    # Escape regex characters
    string = escape(string, '^$.*\/~[]')
    # Escape the line endings
    string = substitute(string, '\n', '\\n', 'g')
    return string
enddef

# Get the current visual block for search and replaces
# This function passed the visual block through a string escape function
# Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
def g:GetVisual(): string
    # Save the current register and clipboard
    var reg_save = getreg('"')
    var regtype_save = getregtype('"')
    var cb_save = &clipboard
    set clipboard&

    # Put the current visual selection in the " register
    normal! ""gvy
    var selection = getreg('"')

    # Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    var clipboard = cb_save

    # Escape any special characters in the selection
    var escaped_selection = EscapeString(selection)

    echo escaped_selection
    return escaped_selection
enddef

# Start the find and replace command across the entire file
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/
