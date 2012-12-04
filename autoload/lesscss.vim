" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: December 04, 2012

function! lesscss#default(name, default) " {{{ set default value if not exist
  if !exists(a:name)
    let {a:name} = a:default
  endif
  return {a:name}
endfunction " }}}
function! lesscss#warn(str) " {{{ echo warning message
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction " }}}
