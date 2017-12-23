require 'magma/ast/expr'

module Magma
  module AST
    class ExprIdentifier < Expr
      visited_as :expr_identifier

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def type(ctx)
        ctx.block.variable(@name).type
      end

      def dump(indent = 0)
        super(indent, @name)
      end

      def generate(ctx)
        ctx.builder.load(ctx.block.variable(@name).value)
      end
    end
  end
end
