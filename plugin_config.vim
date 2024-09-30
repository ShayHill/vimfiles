vim9script

def g:HasPlugin(name: string): bool
	# Search for plugin/name.vim or autoload/name.vim in runtimepath.
	# If found, return true
	# If not found, print a warning and return false
	
	var plugin_roots = [
		$MYVIMDIR .. '/pack/minpac/start/',
		$MYVIMDIR .. '/pack/minpac/opt/'
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


if g:HasPlugin("vim-lsp")
	def OnLspBufferEnabled(): void
		setlocal omnifunc=lsp#complete
		setlocal signcolumn=yes
		if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
		nmap <buffer> <leader>gd <plug>(lsp-definition)
		nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
		nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
		nmap <buffer> <leader>gr <plug>(lsp-references)
		nmap <buffer> <leader>gi <plug>(lsp-implementation)
		nmap <buffer> <leader>gt <plug>(lsp-type-definition)
		nmap <buffer> <leader>rn <plug>(lsp-rename)
		nmap <buffer> [g <plug>(lsp-previous-diagnostic)
		nmap <buffer> ]g <plug>(lsp-next-diagnostic)
		nmap <buffer> K <plug>(lsp-hover)

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
	g:lsp_settings_filetype_python = ['pyright-langserver']

	# use symbols instead of W>, E>, etc.
	g:lsp_diagnostics_signs_error = {'text': '❌'}
	g:lsp_diagnostics_signs_warning = {'text': '🔶'}
	g:lsp_diagnostics_signs_information = {'text': 'ℹ'}
	g:lsp_diagnostics_signs_hint = {'text': '💡'}
	hi lspErrorText ctermbg=NONE guibg=NONE
endif



if g:HasPlugin("asyncomplete.vim")
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	# enter always enters, will not autocomplete.
	inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() .. "\<cr>" : "\<cr>"
endif


if g:HasPlugin("vim-ai")
	# trigger chat or submit query
	inoremap <S-Enter> <Esc>:AIChat<CR>
	nnoremap <S-Enter> :AIChat<CR>
	xnoremap <S-Enter> :AIChat<CR>
endif


if g:HasPlugin("ultisnips")
	g:UltiSnipsExpandTrigger = "<C-l>"
	g:UltiSnipsJumpForwardTrigger = "<C-j>"
	g:UltiSnipsJumpBackwardTrigger = "<C-k>"
endif


if g:HasPlugin("fuzzyy")
	nnoremap <C-P> :FuzzyGitFiles<CR>
	inoremap <C-P> <ESC>:FuzzyGitFiles<CR>
endif


if g:HasPlugin("vimspector")
	g:vimspector_enable_mappings = 'HUMAN'
	g:vimspector_base_dir = $MYVIMDIR .. 'pack\minpac\start\vimspector'
endif


if g:HasPlugin("vim-instant-markdown")
    g:instant_markdown_autostart = 0
    g:instant_markdown_mathjax = 1
endif


if g:HasPlugin("vim9-scratchterm")
    nnoremap <leader>x :update<CR>:ScratchTerm<space>
    inoremap <leader>x <ESC>:update<CR>:ScratchTerm<space>

    nnoremap <leader>v :update<CR>:ScratchTermV<space>
    inoremap <leader>v <ESC>:update<CR>:ScratchTermV<space>

    tnoremap <leader>k <C-w>:ScratchTermsKill<CR>
    nnoremap <leader>k :ScratchTermsKill<CR>
    inoremap <leader>k <ESC>:ScratchTermsKill<CR>

    nnoremap <leader>y :update<CR>:ScratchTerm<t_ku>
    inoremap <leader>y <ESC>:update<CR>:ScratchTerm<t_ku>
endif


if g:HasPlugin("ctrlsf.vim")
    nmap <C-S>f <Plug>CtrlSFPrompt
    vmap <C-S>f <Plug>CtrlSFVwordPath
    vmap <C-S>F <Plug>CtrlSFVwordExec
    nmap <C-S>n <Plug>CtrlSFCwordPath
    nmap <C-S>p <Plug>CtrlSFPwordPath
    nnoremap <C-S>o :CtrlSFOpen<CR>
    nnoremap <C-S>t :CtrlSFToggle<CR>
    inoremap <C-S>t <Esc>:CtrlSFToggle<CR>
endif
