" A simple Vim ftplugin for .wiki files
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
" License:    MIT license
"

if exists('b:current_syntax') | finish | endif
let b:current_syntax = 'wiki'

syntax spell toplevel
syntax sync minlines=100

" {{{1 Headers

for s:i in range(1,6)
  execute 'syntax match wikiHeader' . s:i
        \ . ' /^#\{' . s:i . '}\zs[^#].*/'
        \ . ' contains=@Spell,wikiHeaderChar,wikiTodo,@wikiLink'
endfor
syntax match wikiHeaderChar contained /^#\+/

let s:gcolors = {
      \ 'light' : ['#aa5858','#507030','#1030a0','#103040','#505050','#636363'],
      \ 'dark' : ['#e08090','#80e090','#6090e0','#c0c0f0','#e0e0f0','#f0f0f0']
      \}
let s:ccolors = {
      \ 'light' : ['DarkRed','DarkGreen','DarkBlue','Gray','DarkGray','Black'],
      \ 'dark' : ['Red','Green','Blue','Gray','LightGray','White']
      \}
for s:i in range(6)
  execute 'highlight default wikiHeader' . (s:i + 1)
        \ 'gui=bold term=bold cterm=bold'
        \ 'guifg='   . s:gcolors[&background][s:i]
        \ 'ctermfg=' . s:ccolors[&background][s:i]
endfor

highlight default link wikiHeaderChar Normal

unlet s:i s:gcolors s:ccolors

" }}}1
" {{{1 Links

" Add syntax groups and clusters for links
for [s:group, s:type; s:contained] in [
      \ ['wikiLinkUrl',       'url',        'wikiConcealLink'],
      \ ['wikiLinkUrl',       'cite'],
      \ ['wikiLinkWiki',      'wiki',       'wikiConcealLinkWiki'],
      \ ['wikiLinkRef',       'reference'],
      \ ['wikiLinkRef',       'ref_full',   'wikiConcealLinkRef'],
      \ ['wikiLinkRefTarget', 'ref_target', 'wikiLinkUrl'],
      \ ['wikiLinkMd',        'md',         'wikiConcealLinkMd'],
      \ ['wikiLinkMdImg',     'md_fig',     'wikiConcealLinkMdImg'],
      \ ['wikiLinkDate',      'date'],
      \]
  let s:rx = g:wiki#link#definitions#{s:type}.rx

  execute 'syntax cluster wikiLink  add=' . s:group
  execute 'syntax match' s:group
        \ '/' . s:rx . '/'
        \ 'display contains=@NoSpell'
        \ . (empty(s:contained) ? '' : ',' . join(s:contained, ','))

  call filter(s:contained, 'v:val !~# ''Conceal''')
  execute 'syntax match' s:group . 'T'
        \ '/' . s:rx . '/'
        \ 'display contained contains=@NoSpell'
        \ . (empty(s:contained) ? '' : ',' . join(s:contained, ','))
endfor

" Proper matching of bracketed urls
syntax match wikiLinkUrl "<\l\+:\%(\/\/\)\?[^>]\+>"
      \ display contains=@NoSpell,wikiConcealLink

syntax match wikiConcealLinkUrl
      \ `\%(///\=[^/ \t]\+/\)\zs\S\+\ze\%([/#?]\w\|\S\{15}\)`
      \ cchar=~ contained transparent contains=NONE conceal
syntax match wikiConcealLinkWiki /\[\[\%(\/\|#\)\?\%([^\\\]]\{-}|\)\?/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkWiki /\]\]/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkMd /\[/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkMd /\]([^\\]\{-})/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkMdImg /!\[/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkMdImg /\]([^\\]\{-})/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkRef /[\]\[]\@<!\[/
      \ contained transparent contains=NONE conceal
syntax match wikiConcealLinkRef /\]\[[^\\\[\]]\{-}\]/
      \ contained transparent contains=NONE conceal

highlight default link wikiLinkUrl ModeMsg
highlight default link wikiLinkWiki Underlined
highlight default link wikiLinkMd Underlined
highlight default link wikiLinkMdImg MoreMsg
highlight default link wikiLinkRef Underlined
highlight default link wikiLinkRefTarget Underlined
highlight default link wikiLinkDate MoreMsg

unlet s:group s:type s:contained s:rx

" }}}1
" {{{1 Table

syntax match wikiTable /^\s*|.\+|\s*$/ transparent contains=@wikiInTable,@Spell
syntax match wikiTableSeparator /|/ contained
syntax match wikiTableLine /^\s*[|\-+:]\+\s*$/ contained

syntax match wikiTableFormulaLine /^\s*\/\/ tmf:.*/ contains=wikiTableFormula
syntax match wikiTableFormula /^\s*\/\/ tmf:\zs.*/ contained
      \ contains=wikiTableFormulaChars,wikiTableFormulaSyms
syntax match wikiTableFormulaSyms /[$=():]/ contained
syntax match wikiTableFormulaChars /\a\|,/ contained

for [s:group, s:target] in [
      \ ['wikiTableSeparator', ''],
      \ ['wikiTableLine', ''],
      \ ['wikiTodo', ''],
      \ ['wikiTime', ''],
      \ ['wikiNumber', ''],
      \ ['wikiBoldT', 'wikiBold'],
      \ ['wikiItalicT', 'wikiItalic'],
      \ ['wikiCodeT', 'wikiCode'],
      \ ['wikiLinkUrlT', 'wikiLinkUrl'],
      \ ['wikiLinkWikiT', 'wikiLinkWiki'],
      \ ['wikiLinkRefT', 'wikiLinkRef'],
      \ ['wikiLinkRefTargetT', 'wikiLinkRefTarget'],
      \ ['wikiLinkRefT', 'wikiLinkRef'],
      \ ['wikiLinkMdT', 'wikiLinkMd'],
      \ ['wikiLinkDateT', 'wikiLinkDate'],
      \]
  execute 'syntax cluster wikiInTable add=' . s:group
  if !empty(s:target)
    execute 'highlight default link' s:group s:target
  endif
endfor

highlight default wikiTableSeparator ctermfg=black guifg=#40474d
highlight default link wikiTableLine wikiTableSeparator
highlight default link wikiTableFormulaLine wikiTableSeparator
highlight default link wikiTableFormula Number
highlight default link wikiTableFormulaSyms Special
highlight default link wikiTableFormulaChars ModeMsg
" highlight default wikiTableFormulaLine ctermfg=darkgray guifg=gray
" highlight default wikiTableFormula ctermfg=8 guifg=bg

unlet s:group s:target

" }}}1
" {{{1 Code and nested syntax

syntax match wikiCode /`[^`]\+`/ contains=wikiConcealCode,@NoSpell
syntax match wikiConcealCode contained /`/ conceal
syntax match wikiCodeT /`[^`]\+`/ contained

syntax region wikiPre start=/^\s*```\s*/ end=/```\s*$/ contains=@NoSpell
syntax match wikiPreStart /^\s*```\w\+/ contained contains=wikiPreStartName
syntax match wikiPreEnd /^\s*```\s*$/ contained
syntax match wikiPreStartName /\w\+/ contained

let s:ignored = {
      \ 'sh' : ['shCommandSub', 'shCommandSubBQ'],
      \ 'pandoc' : ['pandocDelimitedCodeBlock', 'pandocNoFormatted'],
      \ 'ruby' : ['rubyString'],
      \ 'make' : ['makeBString', 'makeIdent', 'makeDefine'],
      \ 'resolv' : ['resolvError'],
      \ 'python' : ['pythonFString'],
      \ 'tex' : ['texString', 'texLigature'],
      \ 'muttrc' : ['muttrcShellString', 'muttrcEscape'],
      \ 'neomuttrc' : ['muttrcShellString', 'muttrcEscape'],
      \}

let s:nested_types = ['tex']
let s:nested_types += map(
      \ filter(getline(1, '$'), 'v:val =~# ''^\s*```\w\+\s*$'''),
      \ 'matchstr(v:val, ''```\zs\w\+\ze\s*$'')')
call uniq(sort(s:nested_types))

for s:ft in s:nested_types
  let s:cluster = '@wikiNested' . toupper(s:ft)
  let s:group = 'wikiPre' . toupper(s:ft)

  unlet b:current_syntax
  let s:iskeyword = &l:iskeyword
  let s:fdm = &l:foldmethod
  try
    execute 'syntax include' s:cluster 'syntax/' . s:ft . '.vim'
    execute 'syntax include' s:cluster 'after/syntax/' . s:ft . '.vim'
  catch
  endtry

  for s:ignore in get(s:ignored, s:ft, [])
    execute 'syntax cluster wikiNested' . toupper(s:ft) 'remove=' . s:ignore
  endfor

  let b:current_syntax = 'wiki'
  let &iskeyword = s:iskeyword
  if &l:foldmethod !=# s:fdm
    let &l:foldmethod = s:fdm
  endif

  execute 'syntax region' s:group
        \ 'start=/^\s*```' . s:ft . '/ end=/```\s*$/'
        \ 'keepend transparent'
        \ 'contains=wikiPreStart,wikiPreEnd,@NoSpell,' . s:cluster
endfor

highlight default link wikiCode PreProc
highlight default link wikiPre PreProc
highlight default link wikiPreStart wikiPre
highlight default link wikiPreEnd wikiPre
highlight default link wikiPreStartName Identifier

unlet s:ignored

" }}}1
" {{{1 Lists

syntax match wikiList /^\s*[-*]\ze\s\+/
syntax match wikiList /::\ze\%(\s\|$\)/
syntax match wikiListTodo /^\s*[-*] \[ \]/ contains=wikiList
syntax match wikiListTodoPartial /^\s*[-*] \[[.o]\]/ contains=wikiList
syntax match wikiListTodoDone /^\s*[-*] \[[xX]\]/ contains=wikiList

highlight default link wikiList Identifier
highlight default link wikiListTodo Comment
highlight default link wikiListTodoDone Comment
highlight default link wikiListTodoPartial Comment
highlight wikiListTodo cterm=bold gui=bold
highlight wikiListTodoPartial cterm=none gui=none

" }}}1
" {{{1 Formatting

execute 'syntax match wikiBold'
      \ '/' . wiki#rx#bold . '/'
      \ 'contains=wikiBoldItalic,wikiConcealBold,@Spell'
execute 'syntax match wikiBoldT'
      \ '/' . wiki#rx#bold . '/'
      \ 'contained contains=@Spell'
syntax match wikiConcealBold /*/ contained conceal

execute 'syntax match wikiItalic'
      \ '/' . wiki#rx#italic . '/'
      \ 'contains=wikiItalicBold,wikiConcealItalic,@Spell'
execute 'syntax match wikiItalicT'
      \ '/' . wiki#rx#italic . '/'
      \ 'contained contains=@Spell'
syntax match wikiConcealItalic /_/ contained conceal

execute 'syntax match wikiBoldItalic'
      \ '/' . wiki#rx#italic . '/'
      \ 'contains=wikiConcealBold,wikiConcealItalic,@Spell contained'
execute 'syntax match wikiItalicBold'
      \ '/' . wiki#rx#bold . '/'
      \ 'contains=wikiConcealBold,wikiConcealItalic,@Spell contained'

highlight default wikiBold cterm=bold gui=bold
highlight default wikiItalic cterm=italic gui=italic
highlight default wikiBoldItalic cterm=italic,bold gui=italic,bold
highlight default link wikiItalicBold wikiBoldItalic

" }}}1
" {{{1 Math

" Note: The @wikiNestedTEX is defined earlier!

syntax region wikiEq
      \ start="\$" skip="\\\\\|\\\$" end="\$"
      \ contains=@wikiNestedTEX keepend
syntax region wikiEq
      \ start="\$\$" skip="\\\\\|\\\$" end="\$\$"
      \ contains=@wikiNestedTEX keepend

" }}}1
" {{{1 Miscellaneous

execute 'syntax match wikiTodo /' . wiki#rx#todo . '/'
syntax keyword wikiTodo TODO:
highlight default link wikiTodo Todo

execute 'syntax match wikiDone /' . wiki#rx#done . '/'
syntax keyword wikiDone DONE:
highlight default link wikiDone Statement

syntax region wikiQuote start=/^>\s\+/ end=/^$/
      \ contains=wikiQuoteChar,wikiBold,wikiCode
syntax match wikiQuoteChar contained /^>/
highlight default link wikiQuoteChar Comment
highlight default link wikiQuote Conceal

syntax match wikiNumber  /\d\+\(\.\d\+\)\?/
syntax match wikiIPNum   /\d\+\(\.\d\+\)\{3}/
syntax match wikiVersion /v\d\+\(\.\d\+\)*/
syntax match wikiVersion /\(version\|versjon\) \zs\d\+\(\.\d\+\)*/
syntax match wikiTime    /\d\d:\d\d/
syntax match wikiLine    /^\s*-\{4,}\s*$/
highlight default link wikiNumber  Number
highlight default link wikiIPNum   Identifier
highlight default link wikiVersion Statement
highlight default link wikiTime    Constant
highlight default link wikiLine Identifier

syntax match wikiEnvvar "\$\a\{2,}"
highlight default link wikiEnvvar ModeMsg

" }}}1
