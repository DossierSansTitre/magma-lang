require 'magma/ast/node'

module Magma
  module AST
    class StatementReturn < Node
      visited_as :statement_return

      attr_reader :expr

      def initialize(expr = nil)
        @expr = expr
      end

      def children
        [@expr].reject(&:nil?)
      end
    end
  end
end
