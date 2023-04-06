vim9script

def HasPlugin(name: string): bool
    # return true if a plugin is installed
    var installed_scripts: string
    redir => installed_scripts
    silent exec ':filter \' .. name .. '\ scriptnames'
    redir END
    if installed_scripts == ""
        return v:false
    else
        return v:true
    endif
enddef

# ---------------------------------------------------------------------------- #
#
#  vim-airline
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim-airline")
     g:airline_powerline_fonts = 1
     g:airline_mode_map = {
       \ '__': '-',
       \ 'c': 'C',
       \ 'i': 'I',
       \ 'ic': 'I',
       \ 'ix': 'I',
       \ 'n': 'N',
       \ 'multi': 'M',
       \ 'ni': 'N',
       \ 'no': 'N',
       \ 'R': 'R',
       \ 'Rv': 'R',
       \ 'S': 'S',
       \ '': 'S',
       \ 't': 'T',
       \ 'v': 'V',
       \ 'V': 'V',
       \ '': 'V',
       \ }

     if !exists('g:airline_symbols')
         g:airline_symbols = {}
     endif

     # airline symbols
     g:airline_left_sep = ''
     g:airline_left_alt_sep = ''
     g:airline_right_sep = ''
     g:airline_right_alt_sep = ''
     g:airline_symbols.branch = ''
     g:airline_symbols.readonly = ''
     g:airline_symbols.linenr = ''
     g:airline_symbols.paste = 'ρ'
     g:airline_symbols.whitespace = 'Ξ'
endif



# ---------------------------------------------------------------------------- #
#
#  ultisnips
#
# ---------------------------------------------------------------------------- #

if HasPlugin("ultisnips")
    g:UltiSnipsExpandTrigger = "<C-l>"
    g:UltiSnipsJumpForwardTrigger = "<C-j>"
    g:UltiSnipsJumpBackwardTrigger = "<C-k>"
endif


# ---------------------------------------------------------------------------- #
#
#  asyncomplete
#
# ---------------------------------------------------------------------------- #

if HasPlugin("asyncomplete")
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    # enter always enters, will not autocomplete.
    # inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
endif



# ---------------------------------------------------------------------------- #
#
#  vim-lsp
#
# ---------------------------------------------------------------------------- #

# copied (almost) directly from the vim-lsp docs:
if HasPlugin("vim-lsp")
    def OnLspBufferEnabled(): void
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
        # nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
        # nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

        g:lsp_format_sync_timeout = 1000
        autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    enddef

    augroup lsp_install
        au!
        # call OnLspBufferEnabled (set the lsp shortcuts) when an lsp server
        # is registered for a buffer.
        autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
    augroup END

    # show error information on statusline
    g:lsp_diagnostics_echo_cursor = get(g:, 'lsp_diagnostics_echo_cursor', 1)
    g:lsp_diagnostics_virtual_text_enabled = get(g:, 'lsp_diagnostics_virtual_text_enabled', 0)
endif



# ---------------------------------------------------------------------------- #
#
#  fzf
#
# ---------------------------------------------------------------------------- #

if HasPlugin("fzf.vim")
    nmap <C-p> :FZF<CR>
    imap <C-p> <Esc>:FZF<CR>
    # avoid accidentally triggering fzf :Windows command with :W. With this
    # setting, fzf commands will all require an 'Fzf' prefix.
    g:fzf_command_prefix = 'Fzf'
    # skip some directories when creating ctags
    g:fzf_tags_command = 'ctags -R --exclude=.mypy_cache --exclude=__pycache__ --exclude=__pypackages__ --exclude=node_modules'
    # respect gitignore
    $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif



# ---------------------------------------------------------------------------- #
#
#  gitgutter
#
# ---------------------------------------------------------------------------- #

if HasPlugin("gitgutter")
    nmap <leader>gg :GitGutterToggle<CR>
endif



# ---------------------------------------------------------------------------- #
#
#  scratch_term
#
# ---------------------------------------------------------------------------- #

if HasPlugin("scratch_term")

    nmap <F3> :ScratchTermV<space>

    tnoremap <F4> <C-w>:ScratchTermsKill<CR>
    nnoremap <F4> :ScratchTermsKill<CR>
    inoremap <F4> <ESC>:ScratchTermsKill<CR>

    nnoremap <F8> :update<CR>:ScratchTerm<t_ku>
    inoremap <F8> <ESC>:update<CR>:ScratchTerm<t_ku>
endif



# ---------------------------------------------------------------------------- #
#
#  vim-bbye
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim-bbye")
    nnoremap <Leader>q :Bdelete<CR>
endif



# ---------------------------------------------------------------------------- #
#
#  vim9-stargate
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim9-stargate")
    # For 1 character to search before showing hints
    noremap <leader>f <Cmd>call stargate#OKvim(1)<CR>
    # For 2 consecutive characters to search
    noremap <leader>F <Cmd>call stargate#OKvim(2)<CR>
    # switch panes
    nnoremap <leader>w <Cmd>call stargate#Galaxy()<CR>
    tnoremap <leader>w <C-w>N<Cmd>call stargate#Galaxy()<CR>
endif
