" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: January 20, 2013

" Set default value if not exist {{{

function! lesscss#default(name, default)
  if !exists(a:name)
    let {a:name} = a:default
  endif
  return {a:name}
endfunction

" }}}
" Echo warning message {{{

function! lesscss#warn(str)
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction

" }}}
" Toggle plugin {{{

function! lesscss#toggle()
  if !g:vim_lesscss
    augroup vim_lesscss
      au!
      au BufWritePost *.less silent Lesscss
    augroup END
    call lesscss#warn('lesscss on')
  else
    augroup! vim_lesscss
    call lesscss#warn('lesscss off')
  endif

  let g:vim_lesscss = g:vim_lesscss ? 0 : 1
endfunction

" }}}
" Apply options from dictionary {{{

function! lesscss#apply(opts)
  for [key, value] in items(a:opts)
    let {key} = value
  endfor
endfunction

" }}}
