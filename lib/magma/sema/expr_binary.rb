require 'magma/sema/node'

module Magma
  module Sema
    class ExprBinary < Node
      visited_as :expr_binary

      attr_reader :op
      attr_reader :lhs
      attr_reader :rhs

      def initialize(op, lhs, rhs)
        @op = op
        @lhs = lhs
        @rhs = rhs
      end
    end
  end
end
