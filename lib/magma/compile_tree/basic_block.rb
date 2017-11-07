require 'magma/compile_tree/node'
require 'magma/compile_tree/statement_return'

module Magma
  module CompileTree
    class BasicBlock < Node
      attr_reader :id
      attr_reader :statements

      def initialize(id)
        @id = id
        @statements = []
        @exit_statement = nil
      end

      def visited(v)
        v.basic_block(self)
      end

      def add_return(expr = nil)
        @statements << StatementReturn.new(expr)
      end
    end
  end
end
