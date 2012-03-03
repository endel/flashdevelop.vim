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

  #require 'nokogiri'

  # flashsdk
  puts 'flashsdk'
  require 'flashsdk'
  puts 'asunit4'
  require 'asunit4'

  # FlashDevelop
  require 'flash_develop/controller'
  require 'flash_develop/scope'
  require 'flash_develop/project'

  # Lexic / Parser
  require 'flash_develop/lex/word'
  require 'flash_develop/lex/statement'
  require 'flash_develop/lex/sentence'

  # VIM
  require 'flash_develop/vim/tag'
  require 'flash_develop/vim/vim'
rescue => e
  puts e.inspect
  puts e.backtrace
end
