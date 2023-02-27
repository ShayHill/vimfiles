filetype plugin on " Indent and plugins by filetype
let mapleader=','  " for <leader> shortcuts.
set encoding=utf-8 " setup the encoding to UTF-8
scriptencoding utf-8 " Encoding for this script (to allow Unicode characters)

if has('win32')
    let $VIMFILES = "~/vimfiles"
else
    let $VIMFILES = "~/.vim"
endif

if has("win32")
    source $VIMRUNTIME\..\_vimrc " will contain some diff / Windows nuance
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


" Vim Airline:
let g:airline#extensions#tabline#enabled = 0 " Enable the list of buffers
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
  \ '__'     : '-',
  \ 'c'      : 'C',
  \ 'i'      : 'I',
  \ 'ic'     : 'I',
  \ 'ix'     : 'I',
  \ 'n'      : 'N',
  \ 'multi'  : 'M',
  \ 'ni'     : 'N',
  \ 'no'     : 'N',
  \ 'R'      : 'R',
  \ 'Rv'     : 'R',
  \ 'S'      : 'S',
  \ ''     : 'S',
  \ 't'      : 'T',
  \ 'v'      : 'V',
  \ 'V'      : 'V',
  \ ''     : 'V',
  \ }

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'


" FZF Plugin:
nmap <C-p> :FZF<CR>
imap <C-p> <Esc>:FZF<CR>
" avoid accidentally triggering fzf :Windows command with :W. With this
" setting, fzf commands will all require an 'Fzf' prefix.
let g:fzf_command_prefix = 'Fzf'
nmap <C-]> <Plug>(fzf_tags)
noreabbrev <expr> ts getcmdtype() == ":" && getcmdline() == 'ts' ? 'FZFTselect' : 'ts'

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

set termwinsize=24*0 " set the terminal window size to 24 lines

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


" vertical split to netrw
nmap <F2> :Vex<CR>
imap <F2> <esc>:Vex<CR>

" vertical split to FZF
nmap <F3> :vsplit<CR>:FZF<CR>
imap <F3> <esc>:vsplit<CR>:FZF<CR>

" hard close the integrated terminal with python (started with `:term python`
" or `:term python %`) running by pressing <F4>. ! is required, because
" otherwise Vim will fail to close the buffer and complain about unsaved
" changes. Has to be here instead of ftplugin because it will not retain a
" python filetype if the run fails.  I.e., it's only filetype=plugin when pdb
" or python is running. When it crashes (e.g., python after a stack trace)
" will be in Normal mode. Destroy that buffer with F4 as well, but no ! is
" needed. Safe to close normal-mode buffers. Will ask if unsaved changes.
tnoremap <F4> <C-w>:bd!<CR>
nnoremap <F4> <C-w>:bd<CR>

" <F5> reserved for ftplugins
" <F6> reserved for ftplugins
" <F7> reserved for ftplugins

" last :term command, if any. No <CR>
nnoremap <F8> :update<CR>:term<t_ku>
inoremap <F8> <ESC>:update<CR>:term<t_ku>

" <F11> gvim fullscreen
" <F12> gvim translucency

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
inoremap <C-j> <t_kd>
inoremap <C-k> <t_ku>
inoremap <C-h> <t_kl>
inoremap <C-l> <t_kr>
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



