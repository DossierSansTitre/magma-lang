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

      def generate(builder)
        if @expr.nil?
          builder.ret_void
        else
          builder.ret(@expr.generate)
        end
      end
    end
  end
end
