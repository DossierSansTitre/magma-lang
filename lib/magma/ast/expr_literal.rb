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
        t = type(ctx)
        t_llvm = t.to_llvm
        case t.kind
        when :int
          t_llvm.from_i(@value)
        when :float
          t_llvm.from_f(@value)
        when :bool
          t_llvm.from_i(@value ? 1 : 0)
        end
      end
    end
  end
end
