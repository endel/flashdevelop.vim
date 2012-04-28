# Copyright 2012 Endel Dreyer. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

module FlashDevelop
  class Scope
    attr_reader :class_name, :class_line
    attr_reader :extends, :implements
    attr_reader :imports, :import_line

    def name
      $curbuf.name
    end

    # Buffer path, relative to the project path
    def path
      self.name.gsub("#{VIM::pwd}/", '')
    end

    def package_imported?(full_package_path)
      target_package = full_package_path.match(/(.*)[\.]\w*$/)[1]
      (
        self.package == target_package ||
        @imports.include?(full_package_path) ||
        (package_wildcard = target_package + ".*") &&
        @imports.include?(package_wildcard)
      )
    end

    def import!(package)
      $curbuf.append(@import_line, "\timport #{package};")

      # Set cursor to fixed line number
      cursor = self.cursor
      VIM::set_cursor_position(cursor[0]+1, cursor[1])
    end

    def cursor
      VIM::Window.current.cursor
    end

    def test_file?(test_path)
      File.basename(path).match(/Test\.as$/) && !path.index(/#{test_path}\//).nil?
    end

    def package
      pkg = nil
      currline = 1
      total_lines = self.total_lines
      while !pkg && currline < total_lines
        if matches = $curbuf[currline].match(/package([^\n^{]*)/)
          pkg = matches[1].strip
        end
        currline += 1
      end
      pkg
    end

    def total_lines
      $curbuf.count
    end

    def next_function_line(from_line=1)
      total_lines = self.total_lines

      #
      # Improvement needed.
      #
      next_function_line = total_lines - 3
      while from_line < total_lines
        from_line += 1
        if ($curbuf[from_line].index(Tags::FUNCTION_REGEXP))
          next_function_line = from_line - 1
          break
        end
      end

      next_function_line
    end

    def reindex_headers!
      @imports = []

      last_import_line = nil
      currline = 1
      total_lines = $curbuf.count

      while currline < total_lines
        buff_line = $curbuf[currline]

        # Stop searching if class or interface was found
        if (klass = buff_line.match(/class[^A-Z]*([a-zA-Z0-9_]+)/)) || (interface = buff_line.match(/interface[^A-Z]*([a-zA-Z0-9_]+)/))
          if klass
            @class_name = klass[1]
          end

          if interface
            @class_name = interface[1]
          end

          # Check for inheritance
          @extends = if match_extends = buff_line.match(/extends[\ ]+([^A-Z]*[a-zA-Z0-9_]+)/)
                       extends = match_extends[1]
                       (extends).index('.') ? extends : "#{self.package}.#{extends}"
                     end

          # Check for interface
          @implements = if match_implements = buff_line.match(/implements[\ ]+([^A-Z]*[a-zA-Z0-9_]+)/)
                          implements = match_implements[1]
                          (implements).index('.') ? implements : "#{self.package}.#{implements}"
                        end

          @class_line = currline
          @import_line = last_import_line || (@class_line - 1)
          break
        end

        if matches = buff_line.match(/import ([^;]*)/)
          @imports << matches[1].strip
          last_import_line = currline
        end
        currline += 1
      end
    end

  end
end
