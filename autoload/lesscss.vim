" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.

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
  let g:lesscss_on = 1
  call lesscss#warn('lesscss on')
endfunction

" }}}
" Disable plugin {{{

function! lesscss#off()
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
" Returns option value for current buffer if exists or global otherwise {{{

function! lesscss#get_option(name)
  let name = a:name
  return exists('b:'.name)
        \ ? {'b:'.name}
        \ : {'g:'.name}
endfunction

" }}}
" Add prefix to option dictionary {{{

function! lesscss#prefixed(opts, prefix)
  let rv = {}
  for [key, value] in items(a:opts)
    let rv[a:prefix . key] = value
  endfor
  return rv
endfunction

" }}}
" Initialize plugin {{{

function! lesscss#init()
  " Attach autocmd to run Lesscss on every buffer save.
  augroup vim_lesscss
    au!
    au BufWritePost *.less silent Lesscss
  augroup END

  " Create a command with default options, show warning to user if it try to use
  " the reserved 'default' name.
  if has_key(g:lesscss_commands, 'default')
    call lesscss#warn('The command name ''default'' reserved by lesscss, please use another name')
  endif
  let g:lesscss_commands['default'] = {
        \ 'lesscss_cmd': g:lesscss_cmd,
        \ 'lesscss_save_to': g:lesscss_save_to,
        \ }
endfunction

" }}}
