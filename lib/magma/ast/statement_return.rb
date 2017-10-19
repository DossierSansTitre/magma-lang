require 'magma/ast/node'

module Magma
  module AST
    class StatementReturn < Node
      def initialize(expr = nil)
        @expr = expr
      end

      def children
        [@expr].reject(&:nil?)
      end

      def generate(ast, builder)
        if @expr.nil?
          builder.ret_void
        else
          builder.ret(@expr.generate(ast, builder))
        end
      end
    end
  end
end
