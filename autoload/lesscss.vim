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
  if g:lesscss_on
    call lesscss#off()
  else
    call lesscss#on()
  endif
endfunction

" }}}
" Enable plugin {{{

function! lesscss#on()
  augroup vim_lesscss
    au!
    au BufWritePost *.less silent Lesscss
  augroup END

  let g:lesscss_on = 1
  call lesscss#warn('lesscss on')
endfunction

" }}}
" Disable plugin {{{

function! lesscss#off()
  augroup vim_lesscss
    au!
  augroup END

  let g:lesscss_on = 0
  call lesscss#warn('lesscss off')
endfunction

" }}}
" Apply options from dictionary {{{

function! lesscss#apply(opts)
  for [key, value] in items(a:opts)
    let {key} = value
  endfor
endfunction

" }}}
" Initialize plugin {{{

function! lesscss#init()
  if g:lesscss_on
    silent call lesscss#on()
  else
    silent call lesscss#off()
  endif

  " Create a command with default options, show warning to user if it try to use
  " the reserved 'default' name.
  if has_key(g:lesscss_commands, 'default')
    call lesscss#warn('The command name ''default'' reserved by lesscss, please use another name')
  endif
  let g:lesscss_commands['default'] = {
        \ 'g:lesscss_cmd': g:lesscss_cmd,
        \ 'g:lesscss_save_to': g:lesscss_save_to,
        \ }
endfunction

" }}}
