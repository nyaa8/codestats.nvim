if exists('g:loaded_codestats') | finish | endif

lua codestats = require('codestats')

function! s:gather_xp()
	lua codestats.gather_xp(vim.api.nvim_buf_get_option(0, 'filetype'), 1)
endfunction

function! s:pulse()
	lua codestats.pulse()
endfunction

function! s:exit()
	lua codestats.pulse()
endfunction

augroup codestats
	autocmd!
	autocmd InsertCharPre,TextChanged * call s:gather_xp()
	autocmd VimLeavePre * call s:exit()
	autocmd BufWrite,BufLeave * call s:pulse()
augroup END

let g:loaded_codestats = 1
