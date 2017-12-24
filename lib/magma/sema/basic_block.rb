require 'magma/sema/node'
require 'magma/sema/statement_cond'
require 'magma/sema/statement_jump'
require 'magma/sema/statement_return'

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
        @returned = true
        @statements << StatementCond.new(expr, block_true, block_false)
      end

      def add_jump(block)
        @returned = true
        @statements << StatementJump.new(block)
      end
    end
  end
end
