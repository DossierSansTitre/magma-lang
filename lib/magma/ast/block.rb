require 'magma/ast/node'
require 'magma/ast/variable'

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

      def set_variable(name, type, value)
        v = Variable.new(name, type, value)
        @vars[name] = v
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
