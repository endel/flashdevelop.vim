"
" flashdevelop.vim - AS3 Development Tools for VIM
" Maintainer:   Endel Dreyer <endel.dreyer@gmail.com>
" Version:      0.1
"

"
" actionscript.vim
autocmd Bufread,BufNewFile *.as set filetype=actionscript

"
" indentation
autocmd FileType actionscript setlocal expandtab
autocmd FileType actionscript setlocal tabstop=4
autocmd FileType actionscript setlocal shiftwidth=4
autocmd FileType actionscript setlocal softtabstop=4

"
" ctags setting
" NOTE: You need to copy support/ctags into your ~/.ctags to take advantage from this configuration.
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

