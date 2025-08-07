vim9script

setlocal expandtab  # spaces instead of tabs
setlocal shiftwidth=2  # number of spaces for auto-indent
setlocal softtabstop=2  # a soft-tab of four spaces
setlocal autoindent  # turn on auto-indent

setlocal nowrap

nmap <buffer> <leader>e :update<CR>:source %<CR>
