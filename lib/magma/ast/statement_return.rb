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
        ret_type = ctx.function.type(ctx)
        if @expr.nil?
          ctx.builder.ret_void
        else
          in_type = @expr.type(ctx)
          value = @expr.generate(ctx)
          value = Support::TypeHelper.cast(ctx.builder, in_type, ret_type, value)
          ctx.builder.ret(value)
        end
      end
    end
  end
end
