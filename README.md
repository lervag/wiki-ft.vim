# Introduction

This is a simple [Vim](http://www.vim.org/) filetype plugin for `.wiki` files
that adds some syntax highlighting and very simple folding functions. It
depends on [`wiki.vim`](https://github.com/lervag/wiki.vim) for proper
highlighting of links.

See [`:h
wiki-ft`](https://github.com/lervag/wiki-ft.vim/blob/master/doc/wiki-ft.txt)
for more information.

# Installation

If you use [vim-plug](https://github.com/junegunn/vim-plug), then add the
following lines to your `vimrc` file:

```vim
Plug 'lervag/wiki.vim'
Plug 'lervag/wiki-ft.vim'

" If you do not want to use the wiki.vim plugin:
let g:wiki_loaded = 1
```

