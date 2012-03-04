require 'singleton'

module FlashDevelop
  class Tags
    include Singleton
    TAGS_FILE = 'tags'

    class << self
      def method_missing(method, *args, &block)
        Tags.instance.reload_tags!
        Tags.instance.send(method, *args, &block)
      end
    end

    attr_reader :tags,
                :last_modified

    def initialize
      @last_modified = 0
    end

    def klass(name)
      @tags.match("#{name}\t[^\t]*\t[^\t]*\tc")[0]
    end

    def property(name)
      @tags.match("#{name}\t[^\t]*\t[^\t]*\tp")
    end

    def variable(name)
      @tags.match("#{name}\t[^\t]*\t[^\t]*\tv")
    end

    def method(name)
      @tags.match("#{name}\t[^\t]*\t[^\t]*\tf")
    end

    def reload_tags!
      last_modified = File.ctime(TAGS_FILE).to_i
      if last_modified > @last_modified
        @tags = open(TAGS_FILE).read
        @last_modified = last_modified
      end
    end
  end
end
