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

function s:FlashDevelopRefreshBuffer()
  command -buffer FlashDevelopAutoComplete call <SID>FlashDevelopTryAutocomplete()
  command -buffer FlashDevelopConvertProject call <SID>FlashDevelopConvertProject()
  command -buffer R call <SID>FlashDevelopOpenRelated()
endfunction

function s:FlashDevelopTryAutocomplete()
  ruby $flash_develop.autocomplete
endfunction

function s:FlashDevelopConvertProject()
  ruby $flash_develop.convert_flash_develop_project
endfunction

function s:FlashDevelopOpenRelated()
  ruby $flash_develop.open_related
endfunction

augroup flashdevelop
  autocmd FileType actionscript compiler sprouts
  autocmd FileType actionscript call s:FlashDevelopRefreshBuffer()
  autocmd BufWritePre *.as3proj :FlashDevelopConvertProject
augroup END

ruby << EOF
  begin
    # prepare controller
    puts "Will require..."
    require 'flash_develop'
    puts "Required... Will instantiate"
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
