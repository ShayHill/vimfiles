filetype plugin on " Indent and plugins by filetype
let mapleader=','  " for <leader> shortcuts.
se encoding=utf-8 " setup the encoding to UTF-8
scriptencoding utf-8 " Encoding for this script (to allow Unicode characters)

if has('win32')
    let $VIMFILES = "~/vimfiles"
else
    let $VIMFILES = "~/.vim"
endif


function! PackInit() abort
    packadd minpac
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " everything needed for lsp and completion
    call minpac#add('prabirshrestha/vim-lsp')
    call minpac#add('mattn/vim-lsp-settings')
    call minpac#add('prabirshrestha/asyncomplete.vim')
    call minpac#add('prabirshrestha/asyncomplete-lsp.vim')
    " AI
    call minpac#add('github/copilot.vim')
    " snippets
    call minpac#add('SirVer/ultisnips')
    " the usual suspects
    call minpac#add('vim-airline/vim-airline')
    call minpac#add('vim-airline/vim-airline-themes')
    call minpac#add('tpope/vim-fugitive')  " git integration
    call minpac#add('tpope/vim-sensible')  " sensible defaults
    call minpac#add('tpope/vim-obsession')  " session management
    call minpac#add('tpope/vim-commentary')  " commenting
    call minpac#add('tpope/vim-vinegar')  " netrw enhancement
    call minpac#add('tpope/vim-surround')  " surround text objects
    call minpac#add('psf/black')
    " nice to haves
    call minpac#add('jremmen/vim-ripgrep')  " needs installed ripgrep
    call minpac#add('airblade/vim-gitgutter')  " show git changes
    call minpac#add('dyng/ctrlsf.vim')  " like :CocSearch
    " dispatch's :Make works sometimes when :make won't for PowerShell
    call minpac#add('tpope/vim-dispatch')  " async build
    " fuzzy finding
    call minpac#add('junegunn/fzf')
    call minpac#add('junegunn/fzf.vim')
    " markdown
    call minpac#add('preservim/vim-markdown')  " folding and syntax
    call minpac#add('iamcco/markdown-preview.nvim')  " requires nodejs
    " low-star projects that seem to work OK
    call minpac#add('moll/vim-bbye')  " close a buffer without closing the window
    call minpac#add('monkoose/vim9-stargate')  " easymotion
    " Python
    call minpac#add('tmhedberg/SimpylFold', {'type': 'opt'})  " folding
    call minpac#add('davidszotten/isort-vim-2', {'type': 'opt'})  " isort
    " colorschemes
    call minpac#add('lifepillar/vim-solarized8')
    call minpac#add('lifepillar/vim-gruvbox8')
    call minpac#add('NLKNguyen/papercolor-theme')
    call minpac#add('cocopon/iceberg.vim')
    call minpac#add('arcticicestudio/nord-vim')
    " my plugins
    call minpac#add('shayhill/scratch_term')
endfunction


" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

if has("win32")
    " TODO: uncomment _vimrc line below, and remove this line. Was causing
    " some static when loading my vimrc without airline installed. Have to
    " take a look at the file to see if it's worth sourcing.
    " source $VIMRUNTIME\..\_vimrc " will contain some diff / Windows nuance
    " pwsh (Powershell 7+) breaks plenty of things, so disable it to debug
    " :make etc. Lowercase :make won't work with pwsh, at least not without
    " some obscure configuration I haven't found yet, but tpope/dispatch :Make
    " works fine.
	set shell=pwsh
	" interpreter for Python plugins
    set pythonthreehome=C:\Users\shaya\AppData\Local\Programs\Python\Python310-32
    set pythonthreedll=C:\Users\shaya\AppData\Local\Programs\Python\Python310-32\python310.dll
endif


" =============================================================================
" Other Config Files
" =============================================================================

if has('gui_running')
	source $VIMFILES/gvim.vimrc
endif


" =============================================================================
" Plugins
" =============================================================================

" Asyncomplete:
" enter always enters, will not autocomplete.
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"


" UltiSnips:
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"


" Vim Lsp:

" copied (almost) directly from the vim-lsp docs:
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled (set the lsp shortcuts) when an lsp server
    " is registered for a buffer.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" show error information on statusline
let g:lsp_diagnostics_echo_cursor = get(g:, 'lsp_diagnostics_echo_cursor', 1)
let g:lsp_diagnostics_virtual_text_enabled = get(g:, 'lsp_diagnostics_virtual_text_enabled', 0)




" FZF Plugin:
nmap <C-p> :FZF<CR>
imap <C-p> <Esc>:FZF<CR>
" avoid accidentally triggering fzf :Windows command with :W. With this
" setting, fzf commands will all require an 'Fzf' prefix.
let g:fzf_command_prefix = 'Fzf'
let g:fzf_tags_command = 'ctags -R --exclude=.mypy_cache --exclude=__pycache__ --exclude=__pypackages__ --exclude=node_modules'
" respect .gitignore
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
noreabbrev <expr> ts getcmdtype() == ":" && getcmdline() == 'ts' ? 'FZFTselect' : 'ts'

" GitGutter
nmap <leader>gg :GitGutterToggle<CR>


" =============================================================================
" Colorscheme
" =============================================================================

set t_Co=256 " 256 colors for the terminal
set background=dark " set a dark background
let g:gruvbox_italics = 0 " disable italic comments and keywords
colorscheme iceberg


" =============================================================================
" look for a project-specific spellfile
" =============================================================================

let b:spellfile = expand('%:p:h').'/.vimspell.utf-8.add'
if filereadable(b:spellfile)
    let &l:spellfile = b:spellfile
    setlocal spell
    setlocal spelllang=en_us
else
   setlocal spellfile="go fisjj"
endif


" =============================================================================
" Behaviors
" =============================================================================

" open vertical splits on the right
set splitright

" set termwinsize=24*0 " set the terminal window size to 24 lines

" Keep The Working Directory Clean:
function! MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
	call mkdir(expand(a:path), "p")
    endif
endfunction
set history=1000
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

" Save When Switching Buffers:
set autowrite
set autowriteall
"set hidden " switch buffers w/o saving. here to reming me if I unset autowrite

" Last Modified Line:
" If buffer modified, update any 'last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
    if &modified
	let save_cursor = getpos(".")
	let n = min([20, line("$")])
	keepjumps exe '1,' . n . 's#^\(.\{,10}last modified: \).*#\1' .
	\ strftime("%y%m%d %H:%M:%S") . '#e'
	call histdel('search', -1)
	call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre * call LastModified()

" Common Preference Settings:
set foldlevel=99  " open all folds by default
match IncSearch '\s\+$'  " highlight trailing whitespace

" Searching:
set hlsearch " highlight search results
set ignorecase " ignore case when searching
set smartcase " override ignorecase if search pattern contains upper case

" Indentation:
set expandtab " spaces instead of tabs
set tabstop=4 " a tab = four spaces
set shiftwidth=4 " number of spaces for auto-indent
set softtabstop=4 " a soft-tab of four spaces
set autoindent " turn on auto-indent

" Intuitive File Opening:
set wildmenu  " Command line autocompletion
set wildmode=list:longest,full  " Shows all the options

" Vim Options:
set synmaxcol=176 " speed up by only highlighting first 176 chars
set cursorline " highlight the line under the cursor
set ttyfast " better screen redraw
set showcmd " shows partial commands
set fillchars="fold:" " remove trailing dashes from folds
set scrolloff=5 " screen space around cursor
set sidescrolloff=5 " screen space around cursor
set nowrap " Turn off line wrapping
set noerrorbells " Turn off error bell - still rings for escape in normal mode
" set visualbell " turn on the visual bell


" =============================================================================
" Mappings
" =============================================================================

source $VIMFILES\vim9vimrc.vim



" switch windows
nnoremap <C-J> <C-w>w
nnoremap <C-K> <C-w>W

" return to last position in a globally bookmarked file.
noremap <leader>' <cmd>exec "normal '".getcharstr()."`\""<cr>

" vertical split to netrw
nmap <F2> :Vex<CR>
imap <F2> <esc>:Vex<CR>

" create custom terminals and close all

nmap <F3> :ScratchTerm<space>
tmap <F4> <C-w>:ScratchTermsKill<CR>
nmap <F4> :ScratchTermsKill<CR>

" last :term command, if any. No <CR>
" nnoremap <F8> :update<CR>:term<t_ku>
" inoremap <F8> <ESC>:update<CR>:term<t_ku>

" <F11> gvim fullscreen
" <F12> gvim translucent

" it's so easy to mistype :w that even my mech keyboard somehow does it
" with autoshift.
command! W w

" enter terminal normal mode with <leader>n
tnoremap <leader>n <C-w>N

" remove trailing whitespace
nnoremap <leader>_ :%s/\s\+$//e<CR>

" clear search highlights with space.
nnoremap <space> :noh<CR>

" save as root with :w!!
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

" print the date and time
if has("win32")
    nnoremap <leader>dt "=strftime("%y%m%d %H:%M:%S ")<CR>P
    inoremap <leader>dt <C-R>=strftime("%y%m%d %H:%M:%S ")<CR>
else
    nnoremap <leader>dt "=strftime("%y%m%d %T ")<CR>P
    inoremap <leader>dt <C-R>=strftime("%y%m%d %T ")<CR>
endif

" highlight all characters except ascii printable, \n, and \t. This is for
" finding unicode characters that are hard to see.
nnoremap <leader>np /[ -~\n\t_]\@!<CR>

" refresh highlighting
map <Leader>h :syntax sync fromstart<CR>

" avoid arrow keys
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-h> <t_kl>
cnoremap <C-l> <t_kr>
" inoremap <C-j> <t_kd>
" inoremap <C-k> <t_ku>
" inoremap <C-h> <t_kl>
" inoremap <C-l> <t_kr>
" nnoremap <C-j> <t_kd>
" nnoremap <C-k> <t_ku>
" nnoremap <C-h> <t_kl>
" nnoremap <C-l> <t_kr>
" tnoremap <C-j> <t_kd>
" tnoremap <C-k> <t_ku>
" tnoremap <C-h> <t_kl>
" tnoremap <C-l> <t_kr>

" Buffers:
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" keep rolling if you shift-tab into the integrated terminal
tmap <C-Tab> <C-w>:bnext<cr>
tmap <C-S-Tab> <C-w>:bprevious<cr>

" close a buffer without closing the split
:nnoremap <Leader>q :Bdelete<CR>

" my 40% keyboard has no 6, only k6 (numpad 6), so the built in C-6 command
" won't work without this mapping.
map <C-k6> <C-6>

" Stargate:
" For 1 character to search before showing hints
noremap <leader>f <Cmd>call stargate#OKvim(1)<CR>
" For 2 consecutive characters to search
noremap <leader>F <Cmd>call stargate#OKvim(2)<CR>
" switch panes
nnoremap <leader>w <Cmd>call stargate#Galaxy()<CR>
" switch panes in terminal mode
tnoremap <leader>w <C-w>N<Cmd>call stargate#Galaxy()<CR>

" =============================================================================
" <leader>-z to replace text under cursor, even with special characters
" https://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text/6171215#6171215
" =============================================================================

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Start the find and replace command across the entire file
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/

" =============================================================================
" CRB
" =============================================================================

" prepare CRB files for diff
function! DiffCRB()
    set wrap
    set linebreak
    %s/\s\+$//
    %s/•//g
    %s/•//g
    %s///g
    %s///g
    %s///g
    %s///g
    %s///g
    %s/\t/\r/g
    %s/^\s\+//
    %s/^\w*\n//
    %s/
//g
    %s/​//g
    set wrap
    set linebreak
endfunction

