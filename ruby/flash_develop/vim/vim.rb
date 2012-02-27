module VIM
  def self.cursor_word
    VIM::evaluate('expand("<cword>")')
  end

  def self.input(question, default)
    VIM::evaluate("input(\"#{question}\", \"#{default}\")")
  end

  def self.pwd
    VIM::evaluate('getcwd()')
  end

  def self.open(path)
    VIM::command("open #{path}")
  end
end
