require 'magma/ast/node'
require 'magma/ast/expr_call'
require 'magma/ast/expr_literal'
require 'magma/ast/expr_identifier'

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
