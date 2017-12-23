require 'magma/ast/node'

module Magma
  module AST
    class StatementExpr < Node
      attr_reader :expr

      def initialize(expr)
        @expr = expr
      end

      def children
        [@expr]
      end

      def generate(ctx)
        @expr.generate(ctx)
      end

      def visited(v, *args)
        v.statement_expr(self, *args)
      end
    end
  end
end
