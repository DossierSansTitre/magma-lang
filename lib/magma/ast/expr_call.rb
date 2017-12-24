require 'magma/ast/expr'

module Magma
  module AST
    class ExprCall < Expr
      visited_as :expr_call

      attr_reader :name
      attr_reader :arguments

      def initialize(name)
        @name = name
        @arguments = []
      end

      def add_argument(arg)
        @arguments << arg
      end

      def children
        @arguments
      end

      def dump(indent = 0)
        super(indent, @name)
      end
    end
  end
end
