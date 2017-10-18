module Magma
  module Support
    module NameMangler
      def self.function(name)
        if name == "main"
          "magma_main"
        else
          "magma_func__#{name}"
        end
      end
    end
  end
end
