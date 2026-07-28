vim9script

import autoload 'plugins.vim'

# ---------------------------------------------------------------------------- #
#
#   yegappan/lsp
#
# ---------------------------------------------------------------------------- #

if plugins.IsLoaded('lsp')
  nmap <leader>gd :LspGotoDefinition<CR>
  nmap <leader>gr :LspShowReferences<CR>
  nmap <leader>rn :LspRename<CR>
  nmap <leader>gg :LspDiag current<CR>
  nmap [g :LspDiag prevWrap<CR>
  nmap ]g :LspDiag nextWrap<CR>
  nmap K :LspHover<CR>
endif

if plugins.IsInstalled('lsp')

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
      usePopupInCodeAction: 1,  # numpad and nav require popup version
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

  augroup RegisterLspServers
    autocmd!
    autocmd User LspSetup call RegisterLspServers()
  augroup END
endif


# ---------------------------------------------------------------------------- #
#
#   Minimal Config
#
# ---------------------------------------------------------------------------- #

if plugins.IsLoaded('vim-ai')
  # trigger chat or submit query
  inoremap <S-Enter> <Esc>:AIChat<CR>
  nnoremap <S-Enter> :AIChat<CR>
  xnoremap <S-Enter> :AIChat<CR>
endif


if plugins.IsInstalled('ultisnips')
  g:UltiSnipsExpandTrigger = '<C-l>'
  g:UltiSnipsJumpForwardTrigger = '<C-d>'
  g:UltiSnipsJumpBackwardTrigger = '<C-u>'
endif


if plugins.IsInstalled('fuzzbox.vim')
  g:fuzzbox_enable_mappings = 0
endif

if plugins.IsLoaded('fuzzbox.vim')
  nnoremap <C-P> :FuzzyFiles<CR>
  nnoremap <leader>p :FuzzyArglist<CR>
  inoremap <C-P> <ESC>:FuzzyFiles<CR>
endif


if plugins.IsInstalled('vimspector')
  g:vimspector_enable_mappings = 'HUMAN'
  g:vimspector_base_dir = $MYVIMDIR .. '\pack\minpac\start\vimspector'
endif

if plugins.IsLoaded('vimspector')
  nmap <C-F10> <Plug>VimspectorStepOver
  nmap <C-F11> <Plug>VimspectorStepInto
endif


if plugins.IsInstalled('vim-instant-markdown')
  g:instant_markdown_autostart = 0
  g:instant_markdown_mathjax = 1
endif


if plugins.IsLoaded('vim9-scratchterm')
  nnoremap <leader>x :update<CR>:ScratchTerm<space>
  nnoremap <leader>v :update<CR>:ScratchTermV<space>
  nnoremap <leader>k :ScratchTermsKill<CR>
  nnoremap <leader>y :update<CR>:ScratchTerm<t_ku>
endif


if plugins.IsLoaded('ctrlsf.vim')
  nmap <C-S>f <Plug>CtrlSFPrompt
  vmap <C-S>f <Plug>CtrlSFVwordPath
  vmap <C-S>F <Plug>CtrlSFVwordExec
  nmap <C-S>n <Plug>CtrlSFCwordPath
  nmap <C-S>p <Plug>CtrlSFPwordPath
  nnoremap <C-S>o :CtrlSFOpen<CR>
  nnoremap <C-S>t :CtrlSFToggle<CR>
  inoremap <C-S>t <Esc>:CtrlSFToggle<CR>
endif


if plugins.IsInstalled('vim-translator')
  g:translator_target_lang = 'es'
endif

if plugins.IsLoaded('vim-translator')
  nmap <leader>j :Translate<CR>
  vmap <leader>j :Translate<CR>
  nmap <leader>n :Translate --target_lang='en'<CR>
  vmap <leader>n :Translate --target_lang='en'<CR>
  vmap <leader>jj :TranslateR<CR>
  vmap <leader>nn :TranslateR --target_lang='en'<CR>
endif


if plugins.IsInstalled('vim9-limelight')
  source $MYVIMDIR/limelight_config.vim
endif


if plugins.IsInstalled('easyjump.vim')
  g:easyjump_default_keymap = false
endif

if plugins.IsLoaded('easyjump.vim')
  nmap , <Plug>EasyjumpJump;
  omap , <Plug>EasyjumpJump;
  vmap , <Plug>EasyjumpJump;
endif


if plugins.IsInstalled('vim-pythonsense')
  g:is_pythonsense_suppress_motion_keymaps = 1
endif


if plugins.IsLoaded('coverage-highlight.vim')
  nnoremap <buffer> <leader>c :HighlightCoverage<CR>
  nnoremap <buffer> <leader>C :HighlightCoverageOff<CR>
  nnoremap <buffer> <leader>ct :ToggleCoverage<CR>
  nnoremap <buffer> <leader>cn :NextUncovered<CR>
  nnoremap <buffer> <leader>cp :PrevUncovered<CR>
endif


if plugins.IsInstalled('vim-claude-code')
  g:claude_code_diff_preview = 1
endif

