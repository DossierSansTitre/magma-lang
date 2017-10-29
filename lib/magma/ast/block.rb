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

      def generate(ctx)
        ctx.block = self
        ctx.llvm_block.build do |builder|
          ctx.builder = builder
          @statements.each {|s| s.generate(ctx)}
        end
      end
    end
  end
end
