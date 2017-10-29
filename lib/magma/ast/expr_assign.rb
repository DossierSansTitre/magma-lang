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

      def generate(ctx)
        value = @expr.generate(ctx)
        loc = ctx.block.variable(@name).value
        ctx.builder.store(value, loc)
        value
      end
    end
  end
end
