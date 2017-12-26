require 'magma/ast/node'

module Magma
  module AST
    class StatementLoopControl < Node
      visited_as :statement_loop_control

      attr_reader :op

      def initialize(op)
        @op = op
      end

      def dump(indent)
        super(indent, @op)
      end
    end
  end
end
