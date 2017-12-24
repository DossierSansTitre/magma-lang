require 'magma/ast/expr'
require 'magma/support/name_mangler'

module Magma
  module AST
    class ExprCall < Expr
      visited_as :expr_call

      attr_reader :name
      attr_reader :arguments

      def initialize(name)
        @name = name
        @arguments = []
      end

      def add_argument(arg)
        @arguments << arg
      end

      def children
        @arguments
      end

      def dump(indent = 0)
        super(indent, @name)
      end

      def type(ctx)
        ctx.ast.function(@name).type(ctx)
      end

      def generate(ctx)
        args = []
        f = ctx.ast.function(@func_name)
        @arguments.each_with_index do |expr, i|
          expr_type = expr.type(ctx)
          expr_value = expr.generate(ctx)
          a = f.params[i]
          arg_type = a.type(ctx)
          value = Support::TypeHelper.cast(ctx.builder, expr_type, arg_type, expr_value)
          args << value
        end
        ctx.builder.call(ctx.module.functions[Support::NameMangler.function(@func_name)], *args)
      end
    end
  end
end
