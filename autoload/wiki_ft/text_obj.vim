" A simple Vim ftplugin for .wiki files
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
" License:    MIT license
"

function! wiki_ft#text_obj#code(is_inner, vmode) abort " {{{1
  if !wiki#u#is_code(line('.'))
    if a:vmode
      normal! gv
    endif
    return
  endif

  let l:lnum1 = line('.')
  while 1
    if !wiki#u#is_code(l:lnum1-1) | break | endif
    let l:lnum1 -= 1
  endwhile

  let l:lnum2 = line('.')
  while 1
    if !wiki#u#is_code(l:lnum2+1) | break | endif
    let l:lnum2 += 1
  endwhile

  if a:is_inner
    let l:lnum1 += 1
    let l:lnum2 -= 1
  endif

  call cursor(l:lnum1, 1)
  normal! v
  call cursor(l:lnum2, strlen(getline(l:lnum2)))
endfunction

" }}}1
