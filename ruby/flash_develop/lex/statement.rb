module FlashDevelop
  class Statement
    attr_reader :cursor,
                :sentence,
                :instance

    def initialize(cursor_word, sentence)
      @cursor = Word.new(cursor_word)
      @sentence = Sentence.new(sentence)
    end
  end
end
