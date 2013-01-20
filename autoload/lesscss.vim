" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: January 20, 2013

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
function! lesscss#toggle() " {{{ toggle plugin
  if !g:vim_lesscss
    augroup vim_lesscss
      au!
      au BufWritePost *.less silent Lesscss
    augroup END
    echo 'lesscss on'
  else
    au! vim_lesscss
    echo 'lesscss off'
  endif

  let g:vim_lesscss = g:vim_lesscss ? 0 : 1
endfunction " }}}
