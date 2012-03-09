# FlashDevelop VIM Plugin
# -----------------------
# http://endel.github.com/flashdevelop.vim/
# by Endel Dreyer
#

module FlashDevelop
  class Controller
    attr_reader :project, :current_scope

    def initialize
      @project = Project.new
      @current_scope = Scope.new
    end

    def convert_flash_develop_project
      @project.flash_develop_to_sprouts!(VIM::pwd)
    end

    def open_related
      is_test_file = @current_scope.test_file?(@project.test_path)
      from_path = (is_test_file) ? @project.test_path : @project.src_path
      to_path = (is_test_file) ? @project.src_path : @project.test_path

      # File patterns
      from_extension = (is_test_file) ? /Test\.as$/ : /\.as$/
      to_extension = (is_test_file) ? ".as" : "Test.as"

      target_file = @current_scope.path.gsub(from_path, to_path).gsub(from_extension, to_extension)
      if VIM::file_readable?(target_file)
        VIM::open target_file
      else
        VIM::echoerr "File '#{target_file}' not found."
      end
    end

    # Makes magic, try to discover what to autocomplete, and boom!
    def autocomplete
      statement = Statement.new(VIM::cursor_word, VIM::cursor_sentence)

      if statement.cursor.class?
        tag = Tags.klass(statement.cursor)
        unless tag
          # Try to create class if it doesn't exists
          package = @current_scope.package
          package += (!package.empty? ? "." : '') + statement.cursor
          create_new_class(package)
        else
          # Try to import class if it isn't present on this scope

          @current_scope.reindex_headers!
          unless @current_scope.package_imported?(tag.full_package)
            @current_scope.import!(tag.full_package)
          end
        end

      elsif statement.cursor.const?
        # If statement doesn't exists, try to create it
        unless Tags.variable(statement.cursor, :file => @current_scope.path)
          if access_level_selected = self.ask_access_level("Define constant '#{statement.cursor}' with access level:")
            @current_scope.reindex_headers!
            $curbuf.append(@current_scope.class_line, "\t\t#{access_level_selected} static var #{statement.cursor} : String = \"#{statement.cursor.downcase}\";")
            cursor = @current_scope.cursor
            VIM::set_cursor_position(cursor[0]+1, cursor[1])
          end
        end

      elsif (statement.sentence.function? && !Tags.function(statement.cursor, :file => @current_scope.path))
        # Show options to generate a function if isn't defined on current scope
        if access_level_selected = self.ask_access_level("Create function '#{statement.cursor}' with access level:")

        end

      elsif statement.cursor == "override"
        # Show parent class function list, to select for override
        @current_scope.reindex_headers!
        if @current_scope.extends
          function_tags = Tags.functions(:full_package => @current_scope.extends)
          # Ignore constructor method
          function_tags = function_tags.select {|tag| tag.name != Parser::Package.class_name(@current_scope.extends) }

          tag_selected = if function_tags.length > 1
                           idx = VIM::input_list("Select a function to override:", function_tags.collect { |tag| "#{tag.name} (#{tag.access_level})" } )
                           (idx >= 0) ? function_tags[idx] : nil
                         elsif function_tags.length == 1
                           function_tags.first
                         else
                           VIM::echoerr("Cannot find any function on '#{@current_scope.extends}' to override.")
                         end
          if tag_selected
            $curbuf[@current_scope.cursor[0]] = tag_selected.definition.gsub(/(private|protected|public )/, 'override \1')
            $curbuf.append(@current_scope.cursor[0], "\t\t}")
          end
        else
          VIM::echoerr("Cannot override a base class.")
        end
      end

      #puts statement.cursor.inspect
    end

    def create_new_class(package="")
      full_class_path = VIM::input("New class (full package path): ", package)

      # User skipped
      return if full_class_path.empty?

      # Open generated class
      VIM::open(generate_class(full_class_path))
    end

    def setup_compiler!
      VIM::command("let g:sproutsOptions='#{final_options}'")
      VIM::command('compiler sprouts')
    end

    protected
      # Generate class
      # @example Generating a class
      # self.generate_class('com.util.Math') => "src/com/util/Math.as"
      #
      #
      # @param [String] full_class_path
      # @return [String] class_file_path
      def generate_class(full_class_path)
        VIM::command("!sprout-class #{full_class_path}" )
        "#{@project.src_path}/#{full_class_path.gsub('.', '/')}.as"
      end

      def generate_test

      end

      def generate_suite

      end

      def ask_access_level(question)
        access_levels = {
          1 => 'public',
          2 => 'private',
          3 => 'protected'
        }
        access_levels[VIM::input_list(question, access_levels.values)]
      end
  end
end
