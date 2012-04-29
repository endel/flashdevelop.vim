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

      rakefile = !Dir['rakefile.rb'].first
      as3proj_file = Dir['*.as3proj'].first

      unless rakefile
        generate_sprout_files!(projet_root)
        parse_as3proj(as3proj_file) if as3proj_file
      end
    end

    def identify_project_type(project_root)
      Support::Parser.constants.each do |parser|
        klass = Support::Parser.const_get(parser)

        if Dir[klass::PATTERN].first
          # Return project type identified imediately
          return klass.new
        end
      end

      # Can't identify project type
      nil
    end

  end
end
