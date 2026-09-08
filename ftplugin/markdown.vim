vim9script

if !exists("b:packadd_loaded")
  packadd vim-instant-markdown
  source $MYVIMDIR/after/plugin/plugin_config.vim
endif

b:packadd_loaded = 1
