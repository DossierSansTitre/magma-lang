module Magma
  module AST
    class ExprIdentifier < Node
      def initialize(name)
        @name = name
      end

      def dump(indent = 0)
        super(indent, @name)
      end

      def generate(ast, block, builder)
        block.variable(@name)
      end
    end
  end
end
