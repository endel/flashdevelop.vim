module FlashDevelop
  class Scope

    # Buffer path, relative to the project path
    def path
      $curbuf.name.gsub("#{VIM::pwd}/", '')
    end

    def test?(test_path)
      File.basename(path).match(/Test\.as$/) && !path.index(/#{test_path}\//).nil?
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
