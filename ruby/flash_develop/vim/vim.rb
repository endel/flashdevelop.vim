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

module VIM
  def self.cursor_word
    VIM::evaluate('expand("<cword>")')
  end

  def self.set_cursor_position(x,y)
    VIM::command("call cursor(#{x}, #{y})")
  end

  def self.cursor_sentence
    VIM::evaluate('expand("<cWORD>")')
  end

  def self.get_line(num='.')
    VIM::evaluate("getline('#{num}')")
  end

  def self.input(question, default)
    VIM::evaluate("input(\"#{question}\", \"#{default}\")")
  end

  def self.input_list(question, options, return_type = :si)
    # s  ... Return one selected element
    # si ... Return the index of the selected element
    # m  ... Return a list of selected elements
    # mi ... Return a list of indexes
    VIM::evaluate("tlib#input#List('#{return_type}',\"#{question}\", [#{options.collect {|opt| "'#{opt}'" }.join(',')}]) -1")
  end

  def self.pwd
    VIM::evaluate('getcwd()')
  end

  def self.open(path)
    VIM::command("open #{path}")
  end

  def self.echoerr(str)
    VIM::command("echoerr(\"#{str}\")")
  end

  def self.file_readable?(path)
    VIM::evaluate("file_readable('#{path}')") == 1
  end
end
