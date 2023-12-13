" gvim configuration. gvim_fullscreen.dll is available at https://github.com/movsb/gvim_fullscreen
" Has to be compiled and placed in the vimfiles directory


" when opening for the first time, open at a useful size
if !exists('g:vimrc_sourced')
    let g:vimrc_sourced = 1
    set lines=50
    set columns=120
endif

set go-=T " hide the toolbar
set go-=m " hide the menu
set go-=r " hide all the scrollbars
set go-=R " hide all the scrollbars
set go-=l " hide all the scrollbars
set go-=L " hide all the scrollbars
set go-=b " hide all the scrollbars
set go-=h " hide all the scrollbars

set guifont=Consolas:h10:cANSI:qDRAFT,SimSun-ExtB:h11:cANSI:qDEFAULT,DejaVuSansMono_NFM:h10:cANSI:qDRAFT

 "if has("windows")
 let gvim_fullscreen = expand('$HOME/vimfiles/gvim_fullscreen.dll')
 "   "toggle fullscreen mode by pressing F11
 "   noremap <leader>F11 <esc>:call libcallnr(gvim_fullscreen, 'ToggleFullscreen', 0)<cr>
 "   "toggle window translucency by pressing F12
 "   noremap <leader>F12 <esc>:call libcallnr(gvim_fullscreen, 'ToggleTransparency', "255,180")<cr>

 "   let g:MyVimLib = expand('$HOME/vimfiles/gvim_fullscreen.dll')
"endif

" et gvim_fullscreen = expand('$HOME/vimfiles/gvim_fullscreen.dll')
" noremap <C-F11> <esc>:call libcallnr($VIMRUNTIME .. '/gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>

" let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'
" let g:syntastic_style_error_symbol = '⚡'
" let g:syntastic_style_warning_symbol = '⚡'

" if you can't see the below characters, get a better font
" set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶ " to see: set list!
" set fillchars+=vert:│ " better looking for windows separator



  
