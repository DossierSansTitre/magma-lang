require 'magma/ast/expr'

module Magma
  module AST
    class ExprIdentifier < Expr
      visited_as :expr_identifier

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def dump(indent = 0)
        super(indent, @name)
      end
    end
  end
end
