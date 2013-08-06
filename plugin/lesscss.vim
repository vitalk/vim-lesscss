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
call lesscss#default('g:lesscss_cmd', '/usr/bin/env lessc')

" where to save to
call lesscss#default('g:lesscss_save_to', '')

" enable lesscss by default
call lesscss#default('g:vim_lesscss', 1)

" registered commands
call lesscss#default('g:lesscss_commands', {})

" }}}
" Plugin {{{

function! s:lesscss_pipeline() " {{{ Create css file for less source
  let s:lesscss_out = expand('%:p:h').'/'.g:lesscss_save_to

  " prevent writing to remote dirs like ftp://*
  if s:lesscss_out !~# '\v^\w+\:\/'
    if !isdirectory(s:lesscss_out)
      call lesscss#warn('css dir does not exists, new will be created')
      exe 'silent !mkdir -p '.s:lesscss_out.' > /dev/null 2>&1'
    endif
    exe '!cd %:p:h && '.g:lesscss_cmd.' %:t > '.s:lesscss_out.'%:t:r.css'
  endif
endfunction " }}}

function! s:lesscss(...) " {{{ Run predefined lesscss command
  if empty(a:000)
    if !exists('s:lesscss_last_command')
      call lesscss#warn('Lesscss has not been called yet; no command to reuse!')
      return
    endif
  else
    let s:lesscss_last_command = a:1
  endif

  let command = s:lesscss_last_command

  try
    if has_key(g:lesscss_commands, command)
      let opts = g:lesscss_commands[command]

      " apply custom options
      for [key, value] in items(opts)
        let {key} = value
      endfor

      " silent the less compiler output and force redraw window
      execute ':silent call s:lesscss_pipeline() | :redraw!'
    else
      throw 'Unrecognized command ' . command
    endif
  catch
    call lesscss#warn(v:exception)
  endtry

endf " }}}

" }}}
" Commands {{{

command! -nargs=?
      \  Lesscss  call s:lesscss(<f-args>)

augroup vim_lesscss
  au!
  " create a css file on write but swallow default messages
  au BufWritePost *.less silent Lesscss
augroup END

" }}}
" Key bindings {{{

nnoremap <Leader>l :call lesscss#toggle()<CR>

" }}}
