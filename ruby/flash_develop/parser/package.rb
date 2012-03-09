module FlashDevelop
  module Parser
    class Package
      class << self
        def class_name(full_package)
          full_package.match(/.*[\.](\w*)$/)[1]
        end

        def package(full_package)
          full_package.match(/(.*)[\.]\w*$/)[1]
        end
      end
    end
  end
end
