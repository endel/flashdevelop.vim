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

