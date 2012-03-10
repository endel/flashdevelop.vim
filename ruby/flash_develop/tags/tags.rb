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
