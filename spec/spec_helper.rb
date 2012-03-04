$: << File.expand_path('ruby')

require 'flash_develop.rb'
require 'pp'

#
# VIM interface mock
#
module VIM
  def self.pwd
    "/dummy/"
  end

  class Buffer < String
    class << self
      def load(path)
        $curbuf = self.new(File.expand_path("spec/fixtures/buffer/#{path}"))
      end
    end

    attr_reader :name

    def initialize(path)
      @name = path
      self.clear.concat(open(path).read)
    end

    def count
      self.lines.length
    end

    def [](y)
      self.lines[y-1]
    end

    def lines
      self.split("\n")
    end
  end
end
