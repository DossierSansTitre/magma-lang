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

      def generate(block)
        block.build do |builder|
          @statements.each {|s| s.generate(builder)}
        end
      end
    end
  end
end
