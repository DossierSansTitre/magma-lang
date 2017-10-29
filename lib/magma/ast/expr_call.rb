require 'magma/ast/expr'
require 'magma/support/name_mangler'

module Magma
  module AST
    class ExprCall < Expr
      def initialize(func_name)
        @func_name = func_name
        @arguments = []
      end

      def add_argument(arg)
        @arguments << arg
      end

      def children
        @arguments
      end

      def dump(indent = 0)
        super(indent, @func_name)
      end

      def type(ctx)
        ctx.ast.function(@func_name).type(ctx)
      end

      def generate(ctx)
        args = @arguments.map{ |a| a.generate(ctx) }
        ctx.builder.call(ctx.module.functions[Support::NameMangler.function(@func_name)], *args)
      end
    end
  end
end
