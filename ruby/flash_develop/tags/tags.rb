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

require 'singleton'

module FlashDevelop
  class Tags
    FUNCTION_REGEXP = /^[ \t]*[(private| public|static) ( \t)]*function[ \t]+([A-Za-z0-9_]+)[ \t]*\(/

    include Singleton

    class << self
      def method_missing(method, *args, &block)
        Tags.instance.reload_tags!
        Tags.instance.send(method, *args, &block)
      end
    end

    attr_accessor :tags_file
    attr_reader :tags, :last_modified

    def initialize
      @last_modified = 0
      @tags_file = 'tags'
    end

    def find(name, options={})
      return_tag(name, options[:type] || '[cpvf]', options)
    end

    def klass(name)
      return_tag(name, :c)
    end

    def klasses(options)
      return_tags(:c, options)
    end

    def property(name, options={})
      return_tag(name, :p, options)
    end

    def properties(options)
      return_tags(:p, options)
    end

    def variable(name, options={})
      return_tag(name, :v, options)
    end

    def variables(options)
      return_tags(:v, options)
    end

    def function(name, options={})
      return_tag(name, :f, options)
    end

    def functions(options)
      return_tags(:f, options)
    end

    def reload_tags!
      last_modified = File.ctime(@tags_file).to_i
      if last_modified > @last_modified
        @tags = open(@tags_file).read
        @last_modified = last_modified
      end
    end

    protected

    def return_tag(name, type, options={})
      if match = @tags.match(tag_regexp(name, type, options))
        Tag.new(match)
      end
    end

    def return_tags(type, options)
      @tags.scan(tag_regexp('[^\t]*', type, options)).collect do |match|
        Tag.new(match)
      end
    end

    def tag_regexp(name, type, options)
      file_pattern = if options.empty?
                       '[^\t]*'
                     elsif options[:file]
                       options[:file]
                     elsif options[:class]
                       "[^\\.]*#{options[:class]}\.as"
                     elsif options[:full_package]
                       "src/#{options[:full_package].gsub('.', '/')}.as"
                     elsif options[:package]
                       options[:package] = options[:package][0..-3] if options[:package].index('.*')
                       "src/#{options[:package].gsub('.', '/')}/[^\t]*"
                     end
      /^(#{name})\t(#{file_pattern})\t\/\^([^\$]*)\$\/;"\t(#{type})/
    end

  end
end
