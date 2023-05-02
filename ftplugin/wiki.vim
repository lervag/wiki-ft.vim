" A simple Vim ftplugin for .wiki files
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
" License:    MIT license
"

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

setlocal nolisp
setlocal nomodeline
setlocal nowrap
setlocal foldmethod=expr
setlocal foldexpr=WikiFoldLevel(v:lnum)
setlocal foldtext=WikiFoldText()
setlocal suffixesadd=.wiki
setlocal isfname-=[,]
setlocal autoindent
setlocal nosmartindent
setlocal nocindent
let &l:commentstring = '// %s'
setlocal formatoptions-=o
setlocal formatoptions+=n
let &l:formatlistpat = '\v^\s*%(\d|\l|i+)\.\s'

augroup wiki_buffer
  autocmd BufWinEnter <buffer> setlocal conceallevel=2
augroup END

onoremap <buffer> <plug>(wiki-ac) :call wiki_ft#text_obj#code(0, 0)<cr>
xnoremap <buffer> <plug>(wiki-ac) :<c-u>call wiki_ft#text_obj#code(0, 1)<cr>
onoremap <buffer> <plug>(wiki-ic) :call wiki_ft#text_obj#code(1, 0)<cr>
xnoremap <buffer> <plug>(wiki-ic) :<c-u>call wiki_ft#text_obj#code(1, 1)<cr>

let s:mappings = {
      \ 'o_<plug>(wiki-ac)' : 'ac',
      \ 'x_<plug>(wiki-ac)' : 'ac',
      \ 'o_<plug>(wiki-ic)' : 'ic',
      \ 'x_<plug>(wiki-ic)' : 'ic',
      \}

call wiki#init#apply_mappings_from_dict(s:mappings, '<buffer>')

function! WikiFoldLevel(lnum) abort " {{{1
  let l:line = getline(a:lnum)

  if l:line =~# '^\s*```'
    return wiki#u#is_code(a:lnum+1) ? 'a1' : 's1'
  endif

  if l:line =~# g:wiki#rx#header_md_atx && !wiki#u#is_code(a:lnum)
    return '>' . len(matchstr(l:line, '#*'))
  endif

  return '='
endfunction

" }}}1
function! WikiFoldText() abort " {{{1
  let l:line = getline(v:foldstart)
  let l:text = substitute(l:line, '^\s*', repeat(' ',indent(v:foldstart)), '')
  return l:text
endfunction

" }}}1
