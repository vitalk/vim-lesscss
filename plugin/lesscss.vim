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

" }}}
" Plugin {{{

function! s:lesscss() " {{{ create css file for less source
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

" }}}
" Commands {{{

command! -nargs=0 Lesscss  call s:lesscss()

augroup vim_lesscss
  au!
  " create a css file on write but swallow default messages
  au BufWritePost *.less silent Lesscss
augroup END

" }}}
" Key bindings {{{

nnoremap <Leader>l :call lesscss#toggle()<CR>

" }}}
