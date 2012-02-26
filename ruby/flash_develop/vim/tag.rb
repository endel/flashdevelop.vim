module VIM
  module Tag
    def self.exists?(tag)
      !VIM::evaluate("tselect #{tag}").index('not found').nil?
    end
  end
end
