
if exists('g:loaded_airline') && g:loaded_airline
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
endif
