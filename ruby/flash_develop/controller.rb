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
      if @current_scope.test?(@project.test_path)
        VIM::open @current_scope.path.gsub(@project.test_path, @project.src_path).gsub(/Test\.as$/, ".as")
      else
        VIM::open @current_scope.path.gsub(@project.src_path, @project.test_path).gsub(/\.as$/, "Test.as")
      end
    end

    # Makes magic, try to discover what to autocomplete, and boom!
    def autocomplete
      statement = Statement.new(VIM::cursor_word)

      if statement.class?
        package = @current_scope.package
        package += (!package.empty? ? "." : '') + statement.word
        full_class_path = VIM::input("New class: ", package)

        # User skipped
        return if full_class_path.empty?

        # Open generated class
        VIM::open(generate_class(full_class_path))
      elsif statement.const?

        # If statement doesn't exists, try to create it
        unless VIM::Tag::exists?(current_word)
        end
      end
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
