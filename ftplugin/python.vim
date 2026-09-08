vim9script

if !exists("b:packadd_loaded")
  packadd coverage-highlight.vim
  packadd lsp
  packadd vim-pythonsense
  packadd vimspector
  packadd ultisnips
  packadd vim-dispatch
  source $MYVIMDIR/after/plugin/plugin_config.vim
endif

b:packadd_loaded = 1
