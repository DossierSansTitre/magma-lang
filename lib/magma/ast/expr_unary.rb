require 'magma/ast/expr'

module Magma
  module AST
    class ExprUnary < Expr
      visited_as :expr_unary

      attr_reader :op
      attr_reader :expr

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
    end
  end
end
