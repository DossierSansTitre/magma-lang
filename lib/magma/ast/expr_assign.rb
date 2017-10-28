require 'magma/ast/expr'

module Magma
  module AST
    class ExprAssign < Expr
      def initialize(name, expr)
        @name = name
        @expr = expr
      end

      def children
        [@expr]
      end

      def dump(indent)
        super(indent, @name)
      end

      def generate(ast, block, builder)
        value = @expr.generate(ast, block, builder)
        loc = block.variable(@name).value
        builder.store(value, loc)
        value
      end
    end
  end
end
