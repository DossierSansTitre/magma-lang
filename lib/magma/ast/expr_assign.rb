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

      def type(ctx)
        ctx.block.variable(@name).type
      end

      def generate(ctx)
        in_type = @expr.type(ctx)
        out_type = type(ctx)
        value = @expr.generate(ctx)
        value = Support::TypeHelper.cast(ctx.builder, in_type, out_type, value)
        loc = ctx.block.variable(@name).value
        ctx.builder.store(value, loc)
        value
      end
    end
  end
end
