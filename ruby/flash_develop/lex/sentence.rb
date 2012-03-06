module FlashDevelop
  class Sentence < Word

    def function?
      !self.match(/[a-z0-9]\(/).nil?
    end

    def function_name
      if @word.function?
        (r = @word.match(/\.([^\(]*)/) and r[1])
      end
    end

    def instance
      if instance?
        (r = ((self.namespaced?) ? self.namespaces.last : self).match(/[^\.]+/) and r[1])
      end
    end

    def namespaces
      self.split("::")
    end

    def namespaced?
      @namespaced ||= (colon = self.match(/[A-Z]+[a-zA-Z0-9_]*::.*/) and colon[0] == self)
    end

    def package
      if self.namespaced?
        pkg = self.full_package.clone
        pkg.pop
        pkg
      end
    end

    def full_package
      @full_package ||= begin
                          l = self.namespaces.length
                          pkg = []
                          self.namespaces.each_with_index do |w, i|
                            pkg << ((i == l) ? w : w.downcase)
                          end
                          pkg
                        end
    end
  end
end
