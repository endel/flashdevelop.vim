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
        package = @current_scope.package
        package += (!package.empty? ? "." : '') + statement.cursor
        create_new_class(package)

      elsif statement.cursor.const?

        # If statement doesn't exists, try to create it
        unless VIM::Tag::exists?(statement.cursor)
        end
      end
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
  end
end
