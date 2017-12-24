require 'magma/ast/expr'

module Magma
  module AST
    class ExprLiteral < Expr
      visited_as :expr_literal

      attr_reader :type
      attr_reader :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def dump(indent = 0)
        super(indent, "#{@value}:#{@type}")
      end
    end
  end
end
