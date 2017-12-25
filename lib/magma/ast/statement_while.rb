require 'magma/ast/node'

module Magma
  module AST
    class StatementWhile < Node
      visited_as :statement_while

      attr_reader :expr
      attr_reader :block

      def initialize(expr, block)
        @expr = expr
        @block = block
      end

      def children
        [@expr, @block]
      end
    end
  end
end
