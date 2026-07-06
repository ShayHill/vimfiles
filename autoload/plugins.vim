vim9script

export def IsInstalled(name: string): bool
  # Is plugin directory in $MYVIMDIR/pack/minpac/start or opt?
  # Check before setting g: values, SOME OF WHICH must be defined before a
  # plugin is loaded, otherwise the plugin will not work properly.
  for dir in ['/pack/minpac/start/', '/pack/minpac/opt/']
    if finddir($MYVIMDIR .. dir .. name) != ''
      return true
    endif
  endfor
  echo 'Warning: Plugin ' .. name .. ' is not installed. Dead configuration.'
  return false
enddef


export def IsLoaded(name: string): bool
  # Is the plugin's own directory an entry in RTP?
  # Check before loading mappings.
  const minpac = $MYVIMDIR->substitute('\\', '/', 'g') .. 'pack/minpac/'
  var rtp_entries = split(&runtimepath, ',')
  rtp_entries = rtp_entries->map((_, s) => s->substitute('\\', '/', 'g'))
  for dir in ['start', 'opt']
    const plugin_dir = minpac .. dir .. '/' .. name
    for entry in rtp_entries
      if entry->substitute('\\', '/', 'g') ==# plugin_dir
        return true
      endif
    endfor
  endfor
  return false
enddef

