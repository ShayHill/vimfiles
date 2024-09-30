vim9script

# if you can't see the below characters, get a better font
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶
set fillchars+=vert:│  # for a better looking windows separator

set guifont=DejaVu_Sans_Mono:h10:cANSI:qDRAFT

# open at a useful size
if !exists('g:vimrc_sourced')
    g:vimrc_sourced = 1
    set lines=50
    set columns=120
endif

set go-=T  # hide the toolbar
set go-=m  # hide the menu
set go-=r  # hide the scrollbars
set go-=R  # hide the scrollbars
set go-=l  # hide the scrollbars
set go-=L  # hide the scrollbars
set go-=b  # hide the scrollbars
set go-=h  # hide the scrollbars

g:GvimFullscreenDll = $MYVIMDIR .. 'gvim_fullscreen.dll'
if filereadable(g:GvimFullscreenDll)
	inoremap <C-F11> <Esc>:call libcallnr(g:GvimFullscreenDll, 'ToggleFullscreen', 0)<cr>
	noremap <C-F11> :call libcallnr(g:GvimFullscreenDll, 'ToggleFullscreen', 0)<cr>
	inoremap <C-F12> <Esc>:call libcallnr(g:GvimFullscreenDll, 'ToggleTransparency', '255,180')<cr>
	noremap <C-F12> :call libcallnr(g:GvimFullscreenDll, 'ToggleTransparency', '255,180')<cr>
endif
