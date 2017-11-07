require 'magma/ast/node'

module Magma
  module AST
    class StatementReturn < Node
      attr_reader :expr

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

      def visited(v)
        v.statement_return(self)
      end
    end
  end
end
