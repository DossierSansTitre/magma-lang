require 'magma/sema/node'

module Magma
  module Sema
    class ExprUnary < Node
      visited_as :expr_unary

      attr_reader :op
      attr_reader :expr

      def initialize(op, expr)
        @op = op
        @expr = expr
      end
    end
  end
end
