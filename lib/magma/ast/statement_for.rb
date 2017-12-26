require 'magma/ast/node'

module Magma
  module AST
    class StatementFor < Node
      visited_as :statement_for

      attr_reader :init
      attr_reader :expr
      attr_reader :step
      attr_reader :block

      def initialize(init, expr, step, block)
        @init = init
        @expr = expr
        @step = step
        @block = block
      end

      def children
        [@init, @expr, @step, @block].reject(&:nil?)
      end
    end
  end
end
