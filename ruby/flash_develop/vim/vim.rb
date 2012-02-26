module VIM
  def self.cursor_word
    VIM::evaluate('expand("<cword>")')
  end

  def self.input(question, default)
    VIM::command("input(\"#{question}\", \"#{default}\")")
  end

  def self.pwd
    VIM::evaluate('getcwd()')
  end
end
