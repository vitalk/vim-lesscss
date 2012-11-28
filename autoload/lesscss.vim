" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: Nov 28, 2012

" Set default value if not exist
function! lesscss#default(name, default)
  if !exists(a:name)
    let {a:name} = a:default
  endif
  return {a:name}
endfunction

function! lesscss#warn(str)
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction
