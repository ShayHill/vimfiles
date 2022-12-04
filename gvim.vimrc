" gvim configuration. gvim_fullscreen.dll is available at https://github.com/movsb/gvim_fullscreen
" Has to be compiled and placed in the vimfiles directory

set go-=T " hide the toolbar
set go-=m " hide the menu
set go-=r " hide all the scrollbars
set go-=R " hide all the scrollbars
set go-=l " hide all the scrollbars
set go-=L " hide all the scrollbars
set go-=b " hide all the scrollbars
set go-=h " hide all the scrollbars

set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
"set guifont=Consolas:h9:cANSI
" set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI
set guifont=DejaVuSansMono_NFM:h10:cANSI:qDRAFT


if has("win32")
    let gvim_fullscreen = expand('$HOME/vimfiles/gvim_fullscreen.dll')
    "toggle fullscreen mode by pressing F11
    noremap <f11> <esc>:call libcallnr(gvim_fullscreen, 'ToggleFullscreen', 0)<cr>
    "toggle window translucency by pressing F12
    noremap <f12> <esc>:call libcallnr(gvim_fullscreen, 'ToggleTransparency', "255,180")<cr>
endif

let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '⚡'
let g:syntastic_style_warning_symbol = '⚡'

" if you can't see the below characters, get a better font
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶ " to see: set list!
set fillchars+=vert:│ " better looking for windows separator


