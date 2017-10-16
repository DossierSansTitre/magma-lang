require 'magma/ast/node'
require 'magma/ast/expr_call'

module Magma
  module AST
    class StatementExpr < Node
      def initialize(expr)
        @expr = expr
      end

      def children
        [@expr]
      end
    end
  end
end