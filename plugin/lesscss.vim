" File: lesscss.vim
" Author: Vital Kudzelka
" Description: Vim plugin that make it easy to edit less files without need to manually update corresponding css file.
" Last Modified: Nov 01, 2012

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

  if isdirectory(s:lesscss_out) != 1
    call lesscss#warn('css dir does not exists, created a new one')
    call mkdir(s:lesscss_out, '', 0755)
  endif
  execute '!'.g:lesscss_cmd.' '.shellescape(expand('%')).' > '.shellescape(s:lesscss_out.expand('%:t:r').'.css')
endfunction


" create a css file on write but shallow default messages
" autocmd BufWritePost *.less silent make
autocmd BufWritePost *.less silent call s:lesscss()
