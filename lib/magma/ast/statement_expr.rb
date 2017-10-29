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

      def generate(ast, block, builder)
        @expr.generate(ast, block, builder)
      end
    end
  end
end
