module Magma
  module AST
    class ExprIdentifier < Node
      def initialize(name)
        @name = name
      end

      def dump(indent = 0)
        super(indent, @name)
      end

      def generate(mod, builder)
        value = $named_values[@name]
        builder.load(value, @name)
      end
    end
  end
end
