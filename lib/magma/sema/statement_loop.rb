require 'magma/sema/node'

module Magma
  module Sema
    class StatementLoop < Node
      visited_as :statement_loop

      attr_reader :expr
      attr_reader :block

      def initialize(expr, block)
        @expr = expr
        @block = block
      end
    end
  end
end
