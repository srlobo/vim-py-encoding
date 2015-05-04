" ============================================================================
" File:        pyencoding.vim
" Description: vim global plugin that writes the encoding on the python header
" Maintainer:  Félix Ortega <fortegah at gmail dot com>
" License:     GPLv2
"
" ============================================================================

if exists("loaded_pyencoding") || &cp
	finish
endif
let loaded_pyencoding = 1
let s:keepcpo           = &cpo
set cpo&vim

function! pyencoding#create_or_update_encoding()
	let l:cursor_pos = getpos('.')
	call setpos('.', [0, 1, 1])
	if search("coding[:=]\\s*[-a-zA-Z0-9]\\+ ", 'c', 2)
		" Lo ha encontrado, actualizamos
		call pyencoding#update_encoding()
	else
		" No lo ha encontrado, lo creamos
		call pyencoding#create_encoding()
	endif
	call setpos('.', l:cursor_pos)
endfun

function! pyencoding#create_encoding()
	call setpos('.', [0, 1, 1])

	if search("^#!", 'c', 1) " Hashbang
		let l:startline=1
	else
		let l:startline=0
	endif

	if &fileencoding == ""
		let l:fileencoding = "utf-8" " Lo ponemos a pelo en este caso
	else
		let l:fileencoding = &fileencoding
	endif

	call append(l:startline, '# -*- coding: '. l:fileencoding .' -*-')
endfun

function! pyencoding#update_encoding()
	" Obtenemos el número de líneas
	let l:def_range = 2
	let l:num_lines = line('$')
	if l:num_lines < l:def_range
		let l:def_range = num_lines
	endif

	if &fileencoding == ""
		let l:fileencoding = "utf-8" " Lo ponemos a pelo en este caso
	else
		let l:fileencoding = &fileencoding
	endif

	silent! exe "1,". l:def_range ."s/\\(coding[:=]\\s*\\)[-a-zA-Z0-9]\\+ /\\1" . l:fileencoding . " "
endfun

command! Pyencoding call pyencoding#create_or_update_encoding()

autocmd Bufwritepre,filewritepre *.py call pyencoding#create_or_update_encoding()


