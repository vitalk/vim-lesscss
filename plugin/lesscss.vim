" File:          lesscss.vim
" Author:        Vital Kudzelka
" Version:       0.3
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: January 20, 2013

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
call lesscss#default('g:vim_lesscss', 1)

" default key binding
call lesscss#default('g:lesscss_toggle_key', '<Leader>l')

" registered commands
call lesscss#default('g:lesscss_commands', {
      \ 'nocompress': {'g:lesscss_cmd': '$(which lessc)'},
      \ 'compress':   {'g:lesscss_cmd': '$(which lessc) --compress -O2'},
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
  let s:lesscss_out = expand('%:p:h').'/'.g:lesscss_save_to

  " prevent writing to remote dirs like ftp://*
  if s:lesscss_out !~# '\v^\w+\:\/'
    if !isdirectory(s:lesscss_out)
      exe '!mkdir -p '.s:lesscss_out.' > /dev/null 2>&1'
    endif
    exe '!cd %:p:h && '.g:lesscss_cmd.' %:t > '.s:lesscss_out.'%:t:r.css'
  endif
endfunction

" }}}
" Run predefined lesscss command or reuse previous {{{
" Lesscss [name]
"
" Run previous command if 'name' is skipped. Use 'default' command if nothing to
" reuse.
command! -nargs=?
      \  -complete=customlist,<SID>lesscss_completion
      \  Lesscss  call s:lesscss(<f-args>)

function! s:lesscss(...)
  if empty(a:000)
    let s:lesscss_last_command = exists('s:lesscss_last_command')
          \ ? s:lesscss_last_command
          \ : 'default'
  else
    let s:lesscss_last_command = a:1
  endif

  let command = s:lesscss_last_command

  try
    if has_key(g:lesscss_commands, command)
      let opts = g:lesscss_commands[command]
      call lesscss#apply(opts)

      " silent the less compiler output and force redraw window
      execute ':silent call s:lesscss_pipeline() | :redraw!'
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
