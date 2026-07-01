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


if g:HasPlugin('lsp')
  nmap <leader>gd :LspGotoDefinition<CR>
  nmap <leader>gr :LspShowReferences<CR>
  nmap <leader>rn :LspRename<CR>
  nmap <leader>gg :LspDiag current<CR>
  nmap [g :LspDiag prevWrap<CR>
  nmap ]g :LspDiag nextWrap<CR>
  nmap K :LspHover<CR>

  def RemoveBgFromLspGutterSymbols(): void
    hi LspDiagSignErrorText    guibg=NONE
    hi LspDiagSignWarningText  guibg=NONE
    hi LspDiagSignInfoText     guibg=NONE
    hi LspDiagSignHintText     guibg=NONE
  enddef

  augroup ClearLspGutterSymbolBackgrounds
    autocmd!
    autocmd ColorScheme * call RemoveBgFromLspGutterSymbols()
    autocmd User LspAttached call RemoveBgFromLspGutterSymbols()
    autocmd User LspDiagsUpdated call RemoveBgFromLspGutterSymbols()
  augroup END

  def RegisterLspServers(): void
    var lspOptions = {
      diagSignErrorText: '❌',
      diagSignWarningText: '🔶',
      diagSignInfoText: '🔵',
      diagSignHintText: '💡',
      semanticHighlight: 1,
    }
    lsp#options#OptionsSet(lspOptions)

    var lspServers = [
      {
        name: 'basedpyright',
        filetype: ['python'],
        path: 'basedpyright-langserver',
        args: ['--stdio'],
        workspaceConfig: {python: {pythonPath: exepath('python')}}
      },
      {
        name: 'ruff',
        filetype: ['python'],
        path: 'ruff.exe',
        args: ['server'],
        features: {hover: false}
      }
    ]
    lsp#lsp#AddServer(lspServers)

    RemoveBgFromLspGutterSymbols()
  enddef

  autocmd User LspSetup call RegisterLspServers()
endif


if g:HasPlugin('vim-ai')
  # trigger chat or submit query
  inoremap <S-Enter> <Esc>:AIChat<CR>
  nnoremap <S-Enter> :AIChat<CR>
  xnoremap <S-Enter> :AIChat<CR>
endif


if g:HasPlugin('ultisnips')
  g:UltiSnipsExpandTrigger = '<C-l>'
  g:UltiSnipsJumpForwardTrigger = '<C-d>'
  g:UltiSnipsJumpBackwardTrigger = '<C-u>'
endif


if g:HasPlugin('fuzzbox.vim')
  g:fuzzbox_enable_mappings = 0
  nnoremap <C-P> :FuzzyFiles<CR>
  nnoremap <leader>p :FuzzyArglist<CR>
  inoremap <C-P> <ESC>:FuzzyFiles<CR>
endif


if g:HasPlugin('vimspector')
  g:vimspector_enable_mappings = 'HUMAN'
  # g:vimspector_base_dir = $MYVIMDIR .. '\pack\minpac\start\vimspector'
  nmap <C-F10> <Plug>VimspectorStepOver
  nmap <C-F11> <Plug>VimspectorStepInto
endif


if g:HasPlugin('vim-instant-markdown')
  g:instant_markdown_autostart = 0
  g:instant_markdown_mathjax = 1
endif


if g:HasPlugin('vim9-scratchterm')
  nnoremap <leader>x :update<CR>:ScratchTerm<space>
  nnoremap <leader>v :update<CR>:ScratchTermV<space>
  nnoremap <leader>k :ScratchTermsKill<CR>
  nnoremap <leader>y :update<CR>:ScratchTerm<t_ku>
endif


if g:HasPlugin('ctrlsf.vim')
  nmap <C-S>f <Plug>CtrlSFPrompt
  vmap <C-S>f <Plug>CtrlSFVwordPath
  vmap <C-S>F <Plug>CtrlSFVwordExec
  nmap <C-S>n <Plug>CtrlSFCwordPath
  nmap <C-S>p <Plug>CtrlSFPwordPath
  nnoremap <C-S>o :CtrlSFOpen<CR>
  nnoremap <C-S>t :CtrlSFToggle<CR>
  inoremap <C-S>t <Esc>:CtrlSFToggle<CR>
endif


if g:HasPlugin('vim-translator')
  nmap <leader>j :Translate<CR>
  vmap <leader>j :Translate<CR>
  nmap <leader>n :Translate --target_lang='en'<CR>
  vmap <leader>n :Translate --target_lang='en'<CR>
  vmap <leader>jj :TranslateR<CR>
  vmap <leader>nn :TranslateR --target_lang='en'<CR>
  g:translator_target_lang = 'es'
endif


if g:HasPlugin('vim9-limelight')
  source $MYVIMDIR/limelight_config.vim
endif


if g:HasPlugin('easyjump.vim')
  g:easyjump_default_keymap = false
  nmap , <Plug>EasyjumpJump;
  omap , <Plug>EasyjumpJump;
  vmap , <Plug>EasyjumpJump;
endif


if g:HasPlugin('vim-pythonsense')
  g:is_pythonsense_suppress_motion_keymaps = 1
endif
