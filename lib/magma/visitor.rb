module Magma
  module Visitor
    def visit(target, *args)
      target.visited(self, *args)
    end
  end

  module Visitable
    module ClassMethods
      def visited_as(name)
        define_method("visited") do |v, *args|
          v.__send__(name, self, *args)
        end
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end
