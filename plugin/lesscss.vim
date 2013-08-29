" File:          lesscss.vim
" Author:        Vital Kudzelka
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.

" Guard {{{

if exists("g:loaded_lesscss") || &cp
  finish
endif
let g:loaded_lesscss = 1

" }}}
" Default settings {{{

" less to css executable(full path or executable)
call lesscss#default('g:lesscss_cmd', '$(which lessc)')

" where to save to
call lesscss#default('g:lesscss_save_to', '')

" enable lesscss by default
call lesscss#default('g:lesscss_on', 1)

" default key binding
call lesscss#default('g:lesscss_toggle_key', '<Leader>l')

" registered commands
call lesscss#default('g:lesscss_commands', {
      \ 'on': {'lesscss_on': 1},
      \ 'off': {'lesscss_on': 0},
      \ 'compress':   {'lesscss_cmd': '$(which lessc) --compress -O2'},
      \ 'nocompress': {'lesscss_cmd': '$(which lessc)'},
      \ })

" }}}
" Plugin {{{

" Custom completion list for :Lesscss {{{

function! s:lesscss_completion(arglead, cmdline, cursorpos)
  let names = keys(g:lesscss_commands)
  let cmdonly = substitute(a:cmdline, '^\s*\S\+\s*', '', '')

  return filter(names, 'v:val =~# ''^\V'' . escape(cmdonly, ''\'')')
endf

" }}}
" Create css file for less source {{{

function! s:lesscss_pipeline()
  let lessc = lesscss#get_option('lesscss_cmd')
  let save_to = lesscss#get_option('lesscss_save_to')
  let save_to = expand('%:p:h').'/'.save_to

  " prevent writing to remote dirs like ftp://*
  if save_to !~# '\v^\w+\:\/'
    if !isdirectory(save_to)
      exe '!mkdir -p '.save_to.' > /dev/null 2>&1'
    endif
    exe '!cd %:p:h && '.lessc.' %:t > '.save_to.'%:t:r.css'
  endif
endfunction

" }}}
" Run predefined lesscss command or reuse previous {{{
" Lesscss[!] [cmd]
"
" Run previous command if 'name' is skipped. Use 'default' command if nothing to
" reuse.
"
" Command applied globally unless the ! is provided, in which case the command
" applied only to current buffer.
command! -nargs=?
      \  -bang
      \  -complete=customlist,<SID>lesscss_completion
      \  Lesscss  call s:lesscss(<bang>0, <f-args>)

function! s:lesscss(buffer_only, ...)
  if empty(a:000)
    let g:lesscss_last_command = exists('g:lesscss_last_command')
          \ ? g:lesscss_last_command
          \ : 'default'
  else
    let g:lesscss_last_command = a:1
  endif

  let command = g:lesscss_last_command

  try
    if has_key(g:lesscss_commands, command)
      let opts = g:lesscss_commands[command]
      let opts = lesscss#prefixed(opts, a:buffer_only ? 'b:' : 'g:')
      call lesscss#apply(opts)

      if lesscss#get_option('lesscss_on')
        " silent the less compiler output and force redraw window
        execute ':silent call s:lesscss_pipeline() | :redraw!'
      endif
    else
      throw 'Unrecognized command ' . command
    endif
  catch
    call lesscss#warn(v:exception)
  endtry

endf

" }}}

call lesscss#init()

" }}}
" Key bindings {{{

if !empty(g:lesscss_toggle_key)
  exe 'nnoremap' g:lesscss_toggle_key ':call lesscss#toggle()<CR>'
endif

" }}}
