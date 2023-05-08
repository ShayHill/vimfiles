vim9script
# Configure plugins if installed
# ---------------------------------------------------------------------------- #
# Unfortunately, this is not working. Some of these configurations need to be
# set *before* the plugins are loaded, but I cannot find a way to determine if
# plugins are installed before the plugins are loaded. Their directories are
# not in the &rtp and they do not appear in :scriptnames until after it is too
# late to set their global config variables.
#
# So, HasPlugin() is not working. I have set it up to always return true and
# may revisit this in the future.

if has('win32')
    $VIMFILES = "~/vimfiles"
else
    $VIMFILES = "~/.vim"
endif


def HasPlugin(name: string): bool
    # search for plugin/name.vim or autoload/name.vim in runtimepath. If not
    # found, print error.
    var plugin_roots = [
        $VIMFILES .. '/pack/minpac/start/',
        $VIMFILES .. '/pack/minpac/opt/'
    ]
    var has_plugin = v:false
    for plugin_root in plugin_roots
        has_plugin = has_plugin || finddir(plugin_root .. name) != ''
    endfor
    if ! has_plugin
        echo finddir(plugin_roots[0] .. name)
        echo 'Cannot find plugin ' .. name .. '. Skipping configuration.'
    endif
    return has_plugin
enddef



# ---------------------------------------------------------------------------- #
#
#  vim-airline
#
# ---------------------------------------------------------------------------- #

# if HasPlugin("vim-airline")
#     g:airline_powerline_fonts = 1
#     g:airline_mode_map = {
#                 \ '__': '-',
#                 \ 'c': 'C',
#                 \ 'i': 'I',
#                 \ 'ic': 'I',
#                 \ 'ix': 'I',
#                 \ 'n': 'N',
#                 \ 'multi': 'M',
#                 \ 'ni': 'N',
#                 \ 'no': 'N',
#                 \ 'R': 'R',
#                 \ 'Rv': 'R',
#                 \ 'S': 'S',
#                 \ '': 'S',
#                 \ 't': 'T',
#                 \ 'v': 'V',
#                 \ 'V': 'V',
#                 \ '': 'V',
#                 \ }

#     if !exists('g:airline_symbols')
#         g:airline_symbols = {}
#     endif

#     # airline symbols
#     g:airline_left_sep = '|'
#     g:airline_left_alt_sep = '|'
#     g:airline_right_sep = '|'
#     g:airline_right_alt_sep = '|'

#     # airline brach fuction without symbols
#     g:airline_symbols.branch = ''
#     g:airline_symbols.dirty = '!'
#     g:airline_symbols.notexists = '?'

#     g:airline_symbols.readonly = ''

#     # g:airline_symbols.linenr = ''
#     g:airline_symbols.maxlinenr = ' ☰ '

#     g:airline_symbols.paste = 'ρ'
#     g:airline_symbols.whitespace = 'Ξ'

#     g:airline_section_b = airline#section#create(['hunks', 'branch'])
#     g:airline_section_b = "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"
#     g:airline_section_b = airline#section#create(['branch'])

#     # g:airline_section_c = "%f\ %M"
#     g:airline_section_x = "%#__accent_bold#%l%#__restore__#:%L%{g:airline_symbols.maxlinenr}%#__accent_bold#%v%#__restore__#"
#     # word search, word count, etc. get automatically filled in here, even
#     # when set to ""
#     g:airline_section_y = ""
#     g:airline_section_z = "w%{win_getid()}\ b%n"
#     # g:airline_section_z = "b%n"

#     # don't show errors on the statusline
#     g:airline_section_error = ""
#     g:airline_section_warning = ""
#     g:airline_theme = 'monochrome'
# endif



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

if HasPlugin("asyncomplete.vim")
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    # enter always enters, will not autocomplete.
    inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() .. "\<cr>" : "\<cr>"
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

    # show error information on statusline, no virtual text
    g:lsp_diagnostics_echo_cursor = 1
    g:lsp_diagnostics_virtual_text_enabled = 0
endif



# ---------------------------------------------------------------------------- #
#
#  fzf
#
# ---------------------------------------------------------------------------- #

if 0 && HasPlugin("fzf")
    nmap <C-p> :FZF<CR>
    imap <C-p> <Esc>:FZF<CR>
    # avoid accidentally triggering fzf :Windows command with :W. With this
    # setting, fzf commands will all require an 'Fzf' prefix.
    g:fzf_command_prefix = 'Fzf'
    # skip some directories when creating ctags
    g:fzf_tags_command = 'ctags -R --exclude=.mypy_cache --exclude=__pycache__ --exclude=__pypackages__ --exclude=node_modules'
    # respect gitignore
    $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

    def g:ExecInCmd(command: string)
        # execute a command in Cmd, even when shell is set to pwsh
        var tmp_shell = &shell
        var tmp_shellcmdflag = &shellcmdflag
        var tmp_shellxquote = &shellxquote
        set shell=cmd
        set shellcmdflag=/c
        set shellxquote=
        execute command
        &shell = tmp_shell
        &shellcmdflag = tmp_shellcmdflag
        &shellxquote = tmp_shellxquote
    enddef

    nnoremap <C-g>  :call ExecInCmd('FzfGFiles')<CR>
endif



# ---------------------------------------------------------------------------- #
#
#  gitgutter
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim-gitgutter")
    nmap <leader>gg :GitGutterToggle<CR>
endif



# ---------------------------------------------------------------------------- #
#
#  vim9-scratchterm
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim9-scratchterm")

    nnoremap <F2> :update<CR>:ScratchTerm<space>
    inoremap <F2> <ESC>:update<CR>:ScratchTerm<space>

    nnoremap <F3> :update<CR>:ScratchTermV<space>
    inoremap <F3> <ESC>:update<CR>:ScratchTermV<space>

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



# ---------------------------------------------------------------------------- #
#
#  ctrlsf.vim
#
# ---------------------------------------------------------------------------- #

if HasPlugin("ctrlsf.vim")
    nmap <C-S>f <Plug>CtrlSFPrompt
    vmap <C-S>f <Plug>CtrlSFVwordPath
    vmap <C-S>F <Plug>CtrlSFVwordExec
    nmap <C-S>n <Plug>CtrlSFCwordPath
    nmap <C-S>p <Plug>CtrlSFPwordPath
    nnoremap <C-S>o :CtrlSFOpen<CR>
    nnoremap <C-S>t :CtrlSFToggle<CR>
    inoremap <C-S>t <Esc>:CtrlSFToggle<CR>
endif



# ---------------------------------------------------------------------------- #
#
#  vim-ai
#
# ---------------------------------------------------------------------------- #

if HasPlugin("vim-ai")
    # complete text on the current line or in visual selection
    imap <leader>aa <ESC>:AI<CR>
    nnoremap <leader>aa :AI<CR>
    xnoremap <leader>aa :AI<CR>

    imap <leader>a <ESC>:AI
    nnoremap <leader>a :AI
    xnoremap <leader>a :AI

    # edit text with a custom prompt
    imap <leader>s <ESC>:AIEdit fix grammar and spelling
    xnoremap <leader>s :AIEdit fix grammar and spelling
    nnoremap <leader>s :AIEdit fix grammar and spelling

    # trigger chat
    imap <leader>cc <ESC>:AIChat<CR>
    xnoremap <leader>cc :AIChat<CR>
    nnoremap <leader>cc :AIChat<CR>
endif
