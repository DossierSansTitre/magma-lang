require 'magma/ast/node'

module Magma
  module AST
    class Block < Node
      attr_reader :statements

      def initialize
        @statements = []
        @vars = {}
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
