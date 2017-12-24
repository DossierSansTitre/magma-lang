require 'magma/ast/node'

module Magma
  module AST
    class StatementExpr < Node
      visited_as :statement_expr

      attr_reader :expr

      def initialize(expr)
        @expr = expr
      end

      def children
        [@expr]
      end
    end
  end
end
