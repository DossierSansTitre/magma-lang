require 'magma/ast/node'

module Magma
  module AST
    class StatementReturn < Node
      def initialize(expr = nil)
        @expr = expr
      end

      def children
        [@expr].reject(&:nil?)
      end
    end
  end
end
