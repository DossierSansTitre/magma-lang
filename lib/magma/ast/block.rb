require 'magma/ast/node'
require 'magma/ast/statement_expr'
require 'magma/ast/statement_return'

module Magma
  module AST
    class Block < Node
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

      def set_variable(name, value)
        @vars[name] = value
      end

      def variable(name)
        @vars[name]
      end

      def generate(ast, block)
        block.build do |builder|
          @statements.each {|s| s.generate(ast, self, builder)}
        end
      end
    end
  end
end
