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
  puts 'flash_develop/controller'
  require 'flash_develop/controller'
  puts 'flash_develop/scope'
  require 'flash_develop/scope'
  puts 'flash_develop/project'
  require 'flash_develop/project'
  puts 'flash_develop/statement'
  require 'flash_develop/statement'

  # VIM
  puts 'flash_develop/vim/tag'
  require 'flash_develop/vim/tag'
  puts 'flash_develop/vim/vim'
  require 'flash_develop/vim/vim'
rescue => e
  puts e.inspect
  puts e.backtrace
end
