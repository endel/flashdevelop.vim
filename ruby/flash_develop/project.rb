# Copyright 2012 Endel Dreyer. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require 'erb'
require 'flash_develop/support/parser/fd'

module FlashDevelop
  class Project
    attr_reader :class_name, 
      :bin_path,
      :src_path,
      :test_path,
      :doc_path,
      :debug_swf_name,
      :test_swf_name,
      :test_runner_name

    def initialize
      @doc_path = 'doc'
      @bin_path = 'bin'
      @src_path = 'src'
      @test_path = 'test'
      @debug_swf_name = 'debug.swf'
      @test_swf_name = 'test.swf'
      @test_runner_name = 'test_runner.swf'
    end

    def try_convert!
      project_root = VIM::pwd
      has_rakefile = !Dir['{rakefile.rb,rakefile}*'].first.nil?

      if !has_rakefile
        if project = self.identify_project_type(project_root)
          parser = project[:parser]
          parser.parse( project[:file] )
        else
          parser = nil
        end
        generate_sprout_files!(projet_root, parser)
      end
    end

    def identify_project_type(project_root)
      Support::Parser.constants.each do |parser|
        klass = Support::Parser.const_get(parser)

        if (file = Dir[klass::PATTERN].first)
          # Return identified file and project type immediately
          return {
            :file => file,
            :parser => klass.new
          }
        end
      end

      # Can't identify project type
      nil
    end

    protected

    def generate_sprout_files!(project_root)
      gem_root = Gem.loaded_specs['flashsdk'].full_gem_path
      templates_path = File.join(gem_root, 'lib/flashsdk/generators/templates/')
      ['Gemfile', 'rakefile.rb'].each do |file|
        contents = open("#{templates_path}#{file}").read

        if file == 'rakefile.rb'
          template = ERB.new(contents)

          # Set rakefile variables
          class_name = @class_name
          bin = @bin_path
          src = @src_path
          doc = @doc_path
          debug_swf_name = @debug_swf_name
          test_swf_name = @test_swf_name
          test_runner_name = @test_runner_name

          contents = template.result(binding)

          # debug
          debug_matches = contents.match(/mxmlc \"[^\"]*\" do \|t\|([\s|.|a-zA-Z\._<\"'=\/]*)end/)
          debug_begin, debug_end = debug_matches[0].split(debug_matches[1])
          contents.gsub!(debug_matches[0], "#{debug_begin}#{debug_matches[1].concat(self.mxmlc_options)}#{debug_end}")

          # test suite
          #test_matches = contents.match(/mxmlc \"[^\"]*\" => :asunit4 do \|t\|([\s|.|a-zA-Z\._<\"'=\/]*)end/)
          #test_begin, test_end = test_matches[0].split(test_matches[1])
          #contents.gsub!(test_matches[0], "#{test_begin}#{test_matches[1].concat(self.mxmlc_options)}#{test_end}")

          # swc
          #lib_regexp = /compc \"[^\"]*\" do \|t\|([\s|.|a-zA-Z\._<\"'=\/]*)end/
          #lib_begin, lib_end = lib_matches[0].split(lib_matches[1])
          #contents.gsub!(lib_matches[0], "#{lib_begin}#{lib_matches[1].concat(self.mxmlc_options)}#{lib_end}")
        end

        File.open("#{project_root}/#{file}", "w+") {|f| f.write(contents) }
      end
    end

  end
end
