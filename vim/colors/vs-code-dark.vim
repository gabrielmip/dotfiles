set background=dark
highlight clear
if exists("syntax on")
	syntax reset
endif
let g:colors_name="vs-code-dark"
hi Normal guifg=#e2e2e2 guibg=#292828
hi Comment guifg=#608b4e guibg=NONE
hi Constant guifg=#b4cea8 guibg=NONE
hi String guifg=#d69d85 guibg=NONE
hi htmlTagName guifg=#92caf4 guibg=NONE
hi Identifier guifg=#e2e2e2 guibg=NONE
hi Statement guifg=#569cd6 guibg=NONE
hi PreProc guifg=#ecf0bb guibg=NONE
hi Type guifg=#569cd6 guibg=NONE
hi Function guifg=#e2e2e2 guibg=NONE
hi Repeat guifg=#e2e2e2 guibg=NONE
hi Operator guifg=#e2e2e2 guibg=NONE
hi Error guibg=#ff0000 guifg=#ffffff
hi TODO guibg=#0011ff guifg=#ffffff
hi link character	constant
hi link number	constant
hi link boolean	constant
hi link Float		Number
hi link Conditional	Repeat
hi link Label		Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link htmlTag	Special
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special