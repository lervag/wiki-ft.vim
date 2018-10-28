" A simple Vim ftplugin for .wiki files
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
" License:    MIT license
"

augroup ftdetect
  autocmd BufRead,BufNewFile *.wiki set filetype=wiki
augroup END
