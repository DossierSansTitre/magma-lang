require 'magma/ast/expr'

module Magma
  module AST
    class ExprUnary < Expr
      def initialize(op, expr)
        @op = op
        @expr = expr
      end

      def children
        [@expr]
      end

      def dump(indent)
        super(indent, @op)
      end

      def type(ctx)
        @expr.type(ctx)
      end

      def generate(ctx)
        expr = @expr.generate(ctx)

        case @op
        when :plus
          expr
        when :minus
          ctx.builder.neg(expr)
        when :lnot, :not
          ctx.builder.not(expr)
        end
      end
    end
  end
end
