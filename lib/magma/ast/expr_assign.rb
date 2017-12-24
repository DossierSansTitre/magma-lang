require 'magma/ast/expr'

module Magma
  module AST
    class ExprAssign < Expr
      visited_as :expr_assign

      attr_reader :name
      attr_reader :expr

      def initialize(name, expr)
        @name = name
        @expr = expr
      end

      def children
        [@expr]
      end

      def dump(indent)
        super(indent, @name)
      end
    end
  end
end
