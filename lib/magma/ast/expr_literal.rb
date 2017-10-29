require 'magma/ast/expr'

module Magma
  module AST
    class ExprLiteral < Expr
      def initialize(type, value)
        @type = type
        @value = value
      end

      def type(ctx)
        ctx.ast.types[@type]
      end

      def dump(indent = 0)
        super(indent, "#{@value}:#{@type}")
      end

      def generate(ctx)
        t = ctx.ast.types[@type]
        t_llvm = t.to_llvm
        t_llvm.from_i(@value)
      end
    end
  end
end
