require 'magma/ast/node'
require 'magma/ast/statement_expr'
require 'magma/ast/statement_return'

module Magma
  module AST
    class Block < Node
      def initialize
        @statements = []
      end

      def add_statement(statement)
        @statements << statement
      end

      def children
        @statements
      end
    end
  end
end
