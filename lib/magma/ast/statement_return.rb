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

      def generate(ctx)
        if @expr.nil?
          ctx.builder.ret_void
        else
          ctx.builder.ret(@expr.generate(ctx))
        end
      end
    end
  end
end
