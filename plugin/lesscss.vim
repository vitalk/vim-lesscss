" File:          lesscss.vim
" Author:        Vital Kudzelka
" Version:       0.1
" Description:   Vim plugin that make it easy to edit less files without need to
"                manually update corresponding css file.
" Last Modified: Nov 18, 2012

if exists("g:loaded_lesscss") || &cp
  finish
endif
let g:loaded_lesscss = 1

" less to css executable(full path or executable)
call lesscss#default('g:lesscss_cmd', 'lessc')
" where to save to
call lesscss#default('g:lesscss_save_to', '')


function! s:lesscss()
  let s:lesscss_out = expand('%:p:h').'/'.g:lesscss_save_to

  if !isdirectory(s:lesscss_out)
    call lesscss#warn('css dir does not exists, new will be created')
    call mkdir(s:lesscss_out, '', 0755)
  endif
  execute '!cd %:p:h && '.g:lesscss_cmd.' %:t > '.s:lesscss_out.'%:t:r.css'
endfunction


" create a css file on write but swallow default messages
autocmd BufWritePost *.less silent call s:lesscss()
