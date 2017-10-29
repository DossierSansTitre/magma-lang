require 'magma/ast/node'

module Magma
  module AST
    class StatementExpr < Node
      def initialize(expr)
        @expr = expr
      end

      def children
        [@expr]
      end

      def generate(ctx)
        @expr.generate(ctx)
      end
    end
  end
end
