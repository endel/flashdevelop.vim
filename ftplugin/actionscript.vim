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

" Check if 'tlib_vim' is loaded
try
	call tlib#input#List('mi', '', [])
catch /.*/
	echoe "you're missing tlib. See install instructions at ".expand('<sfile>:h:h').'/README.rst'
endtry

function s:FlashDevelopRefreshBuffer()
  command! -buffer FlashDevelopAutoComplete call <SID>FlashDevelopTryAutocomplete()
  command! -buffer FlashDevelopNewClass call <SID>FlashDevelopCreateNewClass()
  command! -buffer FlashDevelopConvertProject call <SID>FlashDevelopConvertProject()
  command! -buffer R call <SID>FlashDevelopOpenRelated()
endfunction

function s:FlashDevelopTryAutocomplete()
  ruby $flash_develop.autocomplete
endfunction

function s:FlashDevelopConvertProject()
  ruby $flash_develop.project.try_convert!
endfunction

function s:FlashDevelopCreateNewClass()
  ruby $flash_develop.create_new_class
endfunction

function s:FlashDevelopOpenRelated()
  ruby $flash_develop.open_related
endfunction

silent! nnoremap <unique> <silent> <Leader>m :FlashDevelopAutoComplete<CR>
silent! nnoremap <unique> <silent> <Leader>N :FlashDevelopNewClass<CR>

" inoremap <expr><C-m> b:FlashDevelopTryAutocomplete()<CR>

compiler sprouts
call s:FlashDevelopRefreshBuffer()

ruby << EOF
  begin
    # prepare controller
    require 'flash_develop'
    $flash_develop = FlashDevelop::Controller.new
  rescue LoadError
    load_path_modified = false
    ::VIM::evaluate('&runtimepath').to_s.split(',').each do |path|
      lib = "#{path}/ruby"
      if !$LOAD_PATH.include?(lib) and File.exist?(lib)
        $LOAD_PATH << lib
        load_path_modified = true
      end
    end
    retry if load_path_modified
  end
EOF
