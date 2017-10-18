require 'magma/ast/node'
require 'magma/ast/expr_call'
require 'magma/ast/expr_literal'

module Magma
  module AST
    class StatementExpr < Node
      def initialize(expr)
        @expr = expr
      end

      def children
        [@expr]
      end

      def generate(builder)
      end
    end
  end
end
