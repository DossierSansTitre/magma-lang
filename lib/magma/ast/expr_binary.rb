require 'magma/ast/expr'

module Magma
  module AST
    class ExprBinary < Expr
      visited_as :expr_binary

      attr_reader :op
      attr_reader :lhs
      attr_reader :rhs

      def initialize(op, lhs, rhs)
        @op = op
        @lhs = lhs
        @rhs = rhs
      end

      def children
        [@lhs, @rhs]
      end

      def dump(indent)
        super(indent, @op)
      end
    end
  end
end
