" astraios.vim
" Author: Matt Reishus
" Forked from Quantum, thank you for the template
" License: MIT
" Version: 0.1-pre

highlight clear
syntax reset

set background=dark

let g:colors_name = 'astraios'

if !exists('g:stars_italics')
    let g:stars_italics = 0
endif
"let g:stars_italics = 1

let s:gray1     = ['#000000', 0]
let s:gray2     = ['#424242', 238]
let s:gray3     = ['#616161', 241]
let s:gray4     = ['#b0b0b0', 249]
let s:gray5     = ['#c7c7c7', 251]
let s:white     = ['#ffffff', 15]

let s:red       = ['#e06c88', 204]
let s:green     = ['#88c180', 114]
let s:yellow    = ['#dbc375', 221]
let s:blue      = ['#78aee9', 75]
let s:purple    = ['#a785d2', 140]
let s:cyan      = ['#60bdc2', 44]
let s:orange    = ['#e48f6f', 209]
let s:navy      = ['#7986cb', 61]

" Colors I used in mnemosyne.vim       " Its use
let s:mypink = ['#d787d7', 176]     " Used for constants and identifiers
let s:mypaleblue = ['#5f87d7', 68]  " Used for strings
let s:mylightpurple = ['#afafff', 147] " Control statements
let s:myblue = ['#0087ff', 33]      " Function names
" Normal = d0d0d0 252
""" Above were the main colors
let s:mydarkcyan = ['#00afff', 39]
let s:mycyan = ['#87d7ff', 117]     " Special, used for quotes, parens
let s:mypurple = ['#8787ff', 105]   " Class/function stuff
let s:mygreenish = ['#87d787', 114] " Boolean
" Pure white = used for class stuff


function! s:HL(group, fg, bg, attr)
    let l:attr = a:attr
    if g:stars_italics == 0 && l:attr ==? 'italic'
        let l:attr = 'none'
    endif

    if !empty(a:fg)
        exec 'hi ' . a:group . ' guifg=' . a:fg[0] . ' ctermfg=' . a:fg[1]
    endif

    if !empty(a:bg)
        exec 'hi ' . a:group . ' guibg=' . a:bg[0] . ' ctermbg=' . a:bg[1]
    endif

    if l:attr != ''
        exec 'hi ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
    endif
endfun

" Vim Editor
call s:HL('ColorColumn',                    '',         s:gray3,    '')
call s:HL('Cursor',                         s:gray2,    s:white,   '')
call s:HL('CursorColumn',                   '',         s:gray2,    '')
call s:HL('CursorLine',                     '',         s:gray2,    'none')
call s:HL('CursorLineNr',                   s:cyan,     s:gray2,    'none')
call s:HL('Directory',                      s:blue,     '',         '')
call s:HL('DiffAdd',                        s:green,    s:gray2,    'none')
call s:HL('DiffChange',                     s:yellow,   s:gray2,    'none')
call s:HL('DiffDelete',                     s:red,      s:gray2,    'none')
call s:HL('DiffText',                       s:blue,     s:gray1,    'none')
call s:HL('ErrorMsg',                       s:red,      s:gray1,    'bold')
call s:HL('FoldColumn',                     s:gray4,    s:gray2,    '')
call s:HL('Folded',                         s:gray3,    s:gray1,    '')
call s:HL('IncSearch',                      s:yellow,   '',         '')
call s:HL('LineNr',                         s:gray3,    '',         '')
call s:HL('MatchParen',                     s:gray2,    s:cyan,     '')
call s:HL('ModeMsg',                        s:gray4,    '',         '')
call s:HL('MoreMsg',                        s:gray4,    '',         '')
call s:HL('NonText',                        s:gray4,    '',         'none')
call s:HL('Normal',                         s:gray5,    s:gray1,    'none')
call s:HL('Pmenu',                          '',         s:gray3,    '')
call s:HL('PmenuSbar',                      '',         s:gray2,    '')
call s:HL('PmenuSel',                       s:gray2,    s:cyan,     '')
call s:HL('PmenuThumb',                     '',         s:gray4,    '')
call s:HL('Question',                       s:blue,     '',         'none')
call s:HL('Search',                         s:gray1,    s:yellow,   '')
call s:HL('SignColumn',                     '',         s:gray4,    '')
call s:HL('SpecialKey',                     s:gray3,    '',         '')
call s:HL('SpellCap',                       s:blue,     '',         'undercurl')
call s:HL('SpellBad',                       s:red,      '',         'undercurl')
call s:HL('StatusLine',                     s:gray5,    s:gray3,    'none')
call s:HL('StatusLineNC',                   s:gray2,    s:gray4,    '')
call s:HL('TabLine',                        s:gray4,    s:gray2,    'none')
call s:HL('TabLineFill',                    s:gray4,    s:gray2,    'none')
call s:HL('TabLineSel',                     s:gray5,    s:gray3,    'none')
call s:HL('Title',                          s:green,    '',         'none')
call s:HL('VertSplit',                      s:gray4,    s:gray1,    'none')
call s:HL('Visual',                         s:gray5,    s:gray3,    '')
call s:HL('WarningMsg',                     s:red,      '',         '')
call s:HL('WildMenu',                       s:gray2,    s:cyan,	    '')

" Standard Syntax
call s:HL('Comment',                        s:gray4,    '',         'italic')
call s:HL('Constant',                       s:orange,   '',         '')
call s:HL('String',                         s:green,    '',         '')
call s:HL('Character',                      s:green,    '',         '')
call s:HL('Identifier',                     s:red,      '',         'none')
call s:HL('Function',                       s:blue,     '',         '')
call s:HL('Statement',                      s:purple,   '',         'none')
call s:HL('Operator',                       s:cyan,     '',         '')
call s:HL('PreProc',                        s:cyan,     '',         '')
call s:HL('Include',                        s:blue,     '',         '')
call s:HL('Define',                         s:purple,   '',         'none')
call s:HL('Macro',                          s:purple,   '',         '')
call s:HL('Type',                           s:yellow,   '',         'none')
call s:HL('Special',                        s:navy,     '',         '')
call s:HL('Underlined',                     s:blue,     '',         'none')
call s:HL('Error',                          s:red,      s:gray1,    'bold')
call s:HL('Todo',                           s:cyan,     s:gray1,    'bold')

" Vim-Fugitive
call s:HL('diffAdded',                      s:green,    '',         '')
call s:HL('diffRemoved',                    s:red,      '',         '')

" Vim-Gittgutter
call s:HL('GitGutterAdd',                   s:green,    '',         '')
call s:HL('GitGutterChange',                s:yellow,   '',         '')
call s:HL('GitGutterDelete',                s:red,      '',         '')
call s:HL('GitGutterChangeDelete',          s:orange,   '',         '')

" JSX
call s:HL('xmlTag',                s:gray3,    '',   '')
call s:HL('xmlEndTag',             s:gray3,    '',   '')
call s:HL('xmlTagName',            s:purple,    '',   '')
call s:HL('xmlString',             s:orange,    '',   '')
call s:HL('xmlAttrib',             s:blue,    '',   '')

" Javascript
call s:HL('jsModuleKeywords',      s:purple,    '',   '')  " import
call s:HL('jsModuleOperators',     s:purple,    '',   '') " from/as
call s:HL('jsString',              s:orange,    '',   '')
call s:HL('jsNumber',              s:green,    '',   '')
call s:HL('jsVariableDef',         s:blue,    '',   'italic')
call s:HL('jsStorageClass',        s:navy,    '',   '')
call s:HL('jsFunction',            s:cyan,    '',   '')
call s:HL('jsArrowFunction',       s:cyan,    '',   '')
call s:HL('jsParensError',         s:red,    '',   'bold')
call s:HL('jsComment',             s:gray3,    '',   '')
call s:HL('jsDestructuringBlock',  s:blue,    '',   'italic')
call s:HL('jsClassFuncName',       s:yellow,    '',   '')
call s:HL('jsFuncArgs',            s:cyan,    '',   '')

" Vim-Signify
hi link SignifySignAdd GitGutterAdd
hi link SignifySignChange GitGutterChange
hi link SignifySignDelete GitGutterDelete

