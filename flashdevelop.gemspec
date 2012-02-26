Gem::Specification.new do |s|
  s.name = "flashdevelop"

  # see note in the Rakefile about how intermediate version numbers
  # can break RubyGems
  v = `git describe --abbrev=0`.chomp
  s.version = v

  s.authors = ["Endel Dreyer"]
  s.date = "2012-02-26"
  s.email = "endel.dreyer@gmail.com"

  files =
    ["README.md", "LICENSE", "Gemfile", "Rakefile"] +
    Dir.glob("{ruby,doc,plugin}/**/*")

  files = files.reject { |f| f =~ /\.(rbc|o|log|plist|dSYM)/ }

  s.files = files
  s.require_path = "ruby"

  s.executables = []

  s.has_rdoc = false
  s.homepage = "https://github.com/endel/flashdevelop.vim"

  s.summary = "The FlashDevelop plug-in for VIM."

  s.description = <<-EOS
    
  EOS

end
