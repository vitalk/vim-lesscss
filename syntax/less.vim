" File: lesscss.vim
" Author: Vital Kudzelka
" Description: Vim plugin that make it easy to edit less files without need to manually update corresponding css file.
" Last Modified: Nov 01, 2012

execute 'set makeprg=' . g:lesscss_makeprg

autocmd BufWritePost *.less silent make
