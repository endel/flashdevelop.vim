module FlashDevelop
  class Scope
    attr_reader :extends, :implements
    attr_reader :import_line

    def name
      $curbuf.name
    end

    # Buffer path, relative to the project path
    def path
      self.name.gsub("#{VIM::pwd}/", '')
    end

    def package_imported?(full_package_path)
      imports = self.imports
      (imports.include?(full_package_path) || 
        (package_wildcard = full_package_path.match(/(.*)[\.]\w*$/)[1] + ".*") &&
         imports.include?(package_wildcard))
    end

    def import!(package)
      $curbuf.append(@import_line, "\timport #{package};")

      # Set cursor to fixed line number
      cursor = VIM::Window.current.cursor
      VIM::command("call cursor(#{cursor[0]+1}, #{cursor[1]})")
    end

    def imports
      imports = []

      last_import_line = nil
      currline = 1
      total_lines = $curbuf.count

      while currline < total_lines
        buff_line = $curbuf[currline]

        # Stop searching if class or interface was found
        if buff_line.index(/class[^A-Z]*[a-zA-Z0-9_]+/) || buff_line.index(/interface[^A-Z]*[a-zA-Z0-9_]+/)

          # Check for inheritance
          @extends = if match_extends = buff_line.match(/extends[\ ]+([^A-Z]*[a-zA-Z0-9_]+)/)
                       match_extends[1]
                     end

          # Check for interface
          @implements = if match_implements = buff_line.match(/implements[\ ]+([^A-Z]*[a-zA-Z0-9_]+)/)
                          match_implements[1]
                        end

          @import_line = last_import_line || (currline - 1)
          break
        end

        if matches = buff_line.match(/import ([^;]*)/)
          imports << matches[1].strip
          last_import_line = currline
        end
        currline += 1
      end

      imports
    end

    def test_file?(test_path)
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
