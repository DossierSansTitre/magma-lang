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

      def generate(mod, block)
        block.build do |builder|
          @statements.each {|s| s.generate(mod, builder)}
        end
      end
    end
  end
end
