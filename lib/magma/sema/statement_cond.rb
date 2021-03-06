require 'magma/sema/node'

module Magma
  module Sema
    class StatementCond < Node
      visited_as :statement_cond

      attr_reader :expr
      attr_reader :block_true
      attr_reader :block_false

      def initialize(expr, block_true, block_false)
        @expr = expr
        @block_true = block_true
        @block_false = block_false
      end
    end
  end
end
