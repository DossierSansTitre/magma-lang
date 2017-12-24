require 'magma/sema/node'
require 'magma/sema/statement_return'
require 'magma/sema/statement_cond'

module Magma
  module Sema
    class BasicBlock < Node
      attr_reader :id
      attr_reader :statements

      def initialize(id)
        @returned = false
        @id = id
        @statements = []
        @exit_statement = nil
      end

      def returned?
        @returned
      end

      def add_return(expr = nil)
        @returned = true
        @statements << StatementReturn.new(expr)
      end

      def add_expr(expr)
        @statements << expr
      end

      def add_cond(expr, block_true, block_false)
        @statements << StatementCond.new(expr, block_true, block_false)
      end
    end
  end
end
