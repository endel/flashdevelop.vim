module FlashDevelop
  class Scope
    def initialize
    end

    def package
      pkg = nil
      currline = 1
      total_lines = $curbuf.count
      while !pkg && currline < total_lines
        if matches = $curbuf[currline].match(/package([^\n^{]*)/)
          pkg = matches[1].strip
        end
        currline += 1
      end
      pkg
    end
  end
end
