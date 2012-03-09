module FlashDevelop
  class Tag

    attr_reader :name, :file, :definition

    # 
    # Sample Input String
    # 'FlxSprite	src/org/flixel/FlxSprite.as	/^	public class FlxSprite extends FlxObject$/;"	c'
    # 'FlxWeapon	src/org/flixel/plugin/photonstorm/FlxWeapon.as	/^	public class FlxWeapon $/;"	c'
    #
    def initialize(variables)
      if variables.kind_of?(MatchData)
        variables = variables.to_a
        variables.shift
      end
      @name, @file, @definition, @type = variables[0], variables[1], variables[2], variables[3]
    end

    def package
      self.full_package.match(/(.*)[\.]\w*$/)[1]
    end

    def access_level
      (match = @definition.match(/(private|public|protected) /) and match[1])
    end

    def full_package
      # ignore "src/" and ".as" from path
      # TODO: get source path from current Project instance
      @full_package ||= @file[4..-4].gsub('/', '.')
    end

    def class?
      @type == 'c'
    end

    def property?
      @type == 'p'
    end

    def variable?
      @type == 'v'
    end

    def function?
      @type == 'f'
    end
  end
end

