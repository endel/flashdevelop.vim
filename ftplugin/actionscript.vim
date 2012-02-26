"
" flashdevelop.vim - AS3 Development Tools for VIM
" Maintainer:   Endel Dreyer <endel.dreyer@gmail.com>
" Version:      0.1
"

" Exit when already loaded.
if exists("g:loaded_flashdevelop")
  finish
endif
let g:loaded_flashdevelop = 1

function s:FlashDevelopRubyWarning()
  echohl WarningMsg
  echo "flashdevelop.vim requires Vim to be compiled with Ruby support"
  echo "For more information type:  :help flashdevelop"
  echohl none
endfunction

" Check for Ruby functionality.
if !has("ruby")
  call s:FlashDevelopRubyWarning()
  finish
endif

command FlashDevelopAutoComplete call <SID>FlashDevelopTryAutocomplete()
command FlashDevelopConvertProject call <SID>FlashDevelopConvertProject()

function s:FlashDevelopTryAutocomplete()
  ruby $flash_develop.autocomplete
endfunction

function FlashDevelopConvertProject()
  ruby $flash_develop.convert_flash_develop_project
endfunction

silent! nnoremap <unique> <silent> <Leader>m :FlashDevelopAutoComplete<CR>

augroup flashdevelop
  autocmd FileType actionscript compiler sprouts
  autocmd BufWritePre *.as3proj :FlashDevelopConvertProject
augroup END

ruby << EOF
$: << '../ruby'
require 'flash_develop'
$flash_develop = FlashDevelop::FlashDevelop.new
EOF
