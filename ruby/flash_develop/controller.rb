# 
# FlashDevelop VIM Plugin
# -----------------------
# http://endel.github.com/flashdevelop.vim/
# by Endel Dreyer
#

require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'rake/clean'
require 'flashsdk'
require 'asunit4'

require 'nokogiri'


$fd = 1
module FlashDevelop
  class Controller
    attr_reader :project, :generator

    def initialize
      @project = Project.new
      @generator = Generator.new
      @current_scope = Scope.new
    end

    def convert_flash_develop_project
      @project.flash_develop_to_sprouts!(VIM::pwd)
    end

    def autocomplete
      statement = Statement.new(VIM::cursor_word)

      if statement.class?
        package = @scope.package(statement)
        package += ((package.index('.')) ? "." : '') + statement.word
        full_class_path = VIM::input("Generate new class under: ", package)
        generate_class(full_class_path)
      elsif statement.const?

        # If statement doesn't exists, try to create it
        unless VIM::Tag::exists?(current_word)

        end
      end
    end

    def setup_compiler!
      VIM::command("let g:sproutsOptions='#{final_options}'")
      VIM::command('compiler sprouts')
    end

    protected
      # Generators
      def generate_class(full_class_path)
        VIM::command("!sprout-class #{full_class_path}" )
        VIM::command("open #{@project.src_path}/#{full_class_path.gsub('.', '/')}" )
      end

      def generate_test

      end

      def generate_suite

      end
  end
end
