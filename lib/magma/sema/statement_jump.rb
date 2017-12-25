require 'magma/sema/node'

module Magma
  module Sema
    class StatementJump < Node
      visited_as :statement_jump

      attr_reader :block

      def initialize(block)
        @block = block
      end
    end
  end
end
