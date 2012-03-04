module FlashDevelop
  class Word < String
    CONST_REGEXP = /[A-Z_0-9]*/
    CLASS_REGEXP = /[A-Z][a-z]+[a-zA-Z0-9_]+/
    INSTANCE_REGEXP = /[a-z][a-zA-Z_0-9]*/

    def class?
      r = self.match(CLASS_REGEXP) and r[0] == self
    end

    def const?
      r = self.match(CONST_REGEXP) and r[0] == self
    end

    def instance?
      r = self.match(INSTANCE_REGEXP) and r[0] == self
    end
  end
end
