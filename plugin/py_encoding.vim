" ============================================================================
" File:        py_encoding.vim
" Description: vim global plugin that writes the encoding on the python header
" Maintainer:  Félix Ortega <fortegah at gmail dot com>
" License:     GPLv2
"
" ============================================================================

if exists("loaded_py_encoding")
	finish
endif
let loaded_py_encoding = 1

function! py_encoding#update_encoding()
	let cursor_pos = getpos('.')
	silent! exe "1,10s/-\*- coding: \\([^ ]*\\)/&fenc/" 
	call setpos('.',cursor_pos)
endfun
