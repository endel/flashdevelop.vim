module FlashDevelop
  class Statement
    attr_reader :word

    def initialize(word)
      @word = word
    end

    def class?
      @word.match(/[A-Z]+[a-zA-Z_]*/)[0] == @word
    end

    def const?
      @word.match(/[A-Z_]*/)[0] == @word
    end
  end
end
