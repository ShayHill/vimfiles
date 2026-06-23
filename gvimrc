vim9script

# if you can't see the below characters, get a better font
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶
set fillchars+=vert:│  # for a better looking windows separator

set guifont=DejaVu_Sans_Mono:h10:cANSI:qDRAFT

# symbols for render test
# 🌸 (U+1F338) 🌼 (U+1F33C) 🌻 (U+1F33B) 🌺 (U+1F33A) 🌹 (U+1F339)
# 🌷 (U+1F337) 💐 (U+1F490) 🌲 (U+1F332) 🌳 (U+1F333) 🌴 (U+1F334)
# 🌵 (U+1F335) 🌿 (U+1F33F) 🌱 (U+1F331) 🍀 (U+1F340) 🍁 (U+1F341)
# 🍂 (U+1F342) 🍃 (U+1F343) 🍎 (U+1F34E) 🍏 (U+1F34F) 🍐 (U+1F350)
# 🍊 (U+1F34A) 🍋 (U+1F34B) 🍌 (U+1F34C) 🍉 (U+1F349) 🍇 (U+1F347)
# 🍓 (U+1F353) 🍒 (U+1F352) 🍑 (U+1F351) 🥝 (U+1F95D) 🍍 (U+1F34D)
# 🥥 (U+1F965) 🍅 (U+1F345) 🍆 (U+1F346) 🥑 (U+1F951) 🥒 (U+1F952)
# 🌽 (U+1F33D) 🥕 (U+1F955) 🥔 (U+1F954) 🧄 (U+1F9C4) 🧅 (U+1F9C5)

set renderoptions=type:directx,gamma:1.0,geom:0,renmode:5,taamode:1

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

# toggle fullscreen
map <expr> <F11> &go =~# 's' ? ":se go-=s<CR>" : ":se go+=s<CR>"

