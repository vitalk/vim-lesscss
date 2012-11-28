" File:          lesscss.vim
" Author:        Vital Kudzelka
" Version:       0.2
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: Nov 28, 2012

if exists("g:loaded_lesscss") || &cp
  finish
endif
let g:loaded_lesscss = 1

" less to css executable(full path or executable)
call lesscss#default('g:lesscss_cmd', '/usr/bin/env lessc')
" where to save to
call lesscss#default('g:lesscss_save_to', '')


function! s:lesscss()
  let s:lesscss_out = expand('%:p:h').'/'.g:lesscss_save_to

  " prevent writing to remote dirs like ftp://*
  if s:lesscss_out !~# '\v^\w+\:\/'
    if !isdirectory(s:lesscss_out)
      call lesscss#warn('css dir does not exists, new will be created')
      exe 'silent !mkdir -p '.s:lesscss_out.' > /dev/null 2>&1'
    endif
    exe '!cd %:p:h && '.g:lesscss_cmd.' %:t > '.s:lesscss_out.'%:t:r.css'
  endif
endfunction


" create a css file on write but swallow default messages
autocmd BufWritePost *.less silent call s:lesscss()
