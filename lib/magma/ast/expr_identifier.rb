require 'magma/ast/expr'

module Magma
  module AST
    class ExprIdentifier < Expr
      def initialize(name)
        @name = name
      end

      def dump(indent = 0)
        super(indent, @name)
      end

      def generate(ast, block, builder)
        builder.load(block.variable(@name).value)
      end
    end
  end
end
