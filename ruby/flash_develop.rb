# 
# FlashDevelop VIM Plugin
# -----------------------
# http://endel.github.com/flashdevelop.vim/
# by Endel Dreyer
#

# Bundler
begin
  require 'rubygems'
  require 'bundler'
  Bundler.setup

  # flashsdk
  require 'flashsdk'
  require 'asunit4'

  # FlashDevelop
  require 'flash_develop/controller'
  require 'flash_develop/scope'
  require 'flash_develop/project'
  require 'flash_develop/tags'

  # Lexic / Parser
  require 'flash_develop/lex/word'
  require 'flash_develop/lex/statement'
  require 'flash_develop/lex/sentence'

  # VIM
  require 'flash_develop/vim/vim'
rescue => e
  puts e.inspect
  puts e.backtrace
end
