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
  class Sentence < Word

    def function?
      !self.match(/[a-z0-9]\(/).nil?
    end

    def function_name
      if @word.function?
        (r = @word.match(/\.([^\(]*)/) and r[1])
      end
    end

    def instance
      if instance?
        (r = ((self.namespaced?) ? self.namespaces.last : self).match(/[^\.]+/) and r[1])
      end
    end

    def namespaces
      self.split("::")
    end

    def namespaced?
      @namespaced ||= (colon = self.match(/[A-Z]+[a-zA-Z0-9_]*::.*/) and colon[0] == self)
    end

    def package
      if self.namespaced?
        pkg = self.full_package.clone
        pkg.pop
        pkg
      end
    end

    def full_package
      @full_package ||= begin
                          l = self.namespaces.length
                          pkg = []
                          self.namespaces.each_with_index do |w, i|
                            pkg << ((i == l) ? w : w.downcase)
                          end
                          pkg
                        end
    end
  end
end
