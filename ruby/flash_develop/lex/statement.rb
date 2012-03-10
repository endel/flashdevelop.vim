module FlashDevelop
  class Statement
    attr_reader :cursor,
                :sentence,
                :instance

    def initialize(cursor_word, sentence, line)
      @cursor = Word.new(cursor_word)
      @sentence = Sentence.new(sentence)
      @line = line
    end

    def function
      if @sentence.function?
        {
          :name => @cursor,
          :args => (args = @line.match(/#{@cursor}\(([^\)]*)\)/) and args[1])
        }
      end
    end

    def property
      #
      # Not implemented
      #
    end

  end
end
