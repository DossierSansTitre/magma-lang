require 'magma/ast/expr'

module Magma
  module AST
    class ExprLiteral < Expr
      attr_reader :type
      attr_reader :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def dump(indent = 0)
        super(indent, "#{@value}:#{@type}")
      end

      def visited(v, *args)
        v.expr_literal(self, *args)
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
