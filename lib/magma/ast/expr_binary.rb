require 'magma/ast/expr'
require 'magma/support/type_helper'

module Magma
  module AST
    class ExprBinary < Expr
      LOGICAL_IN = [
        :lor,
        :land
      ]

      LOGICAL_OUT = [
        :eq,
        :ne,
        :gt,
        :ge,
        :lt,
        :le
      ]

      attr_reader :op
      attr_reader :lhs
      attr_reader :rhs

      def initialize(op, lhs, rhs)
        @op = op
        @lhs = lhs
        @rhs = rhs
      end

      def children
        [@lhs, @rhs]
      end

      def dump(indent)
        super(indent, @op)
      end

      def internal_type(ctx)
        if LOGICAL_IN.include?(@op)
          ctx.ast.types.find_minimal(:bool, 1)
        else
          lhs_type = @lhs.type(ctx)
          rhs_type = @rhs.type(ctx)
          ctx.ast.types.result_type(lhs_type, rhs_type)
        end

      end

      def type(ctx)
        if LOGICAL_OUT.include?(@op)
          ctx.ast.types.find_minimal(:bool, 1)
        else
          internal_type(ctx)
        end
      end

      def generate(ctx)
        lhs = @lhs.generate(ctx)
        rhs = @rhs.generate(ctx)
        t = internal_type(ctx)
        lhs_type = @lhs.type(ctx)
        rhs_type = @rhs.type(ctx)

        lhs = Support::TypeHelper.cast(ctx.builder, lhs_type, t, lhs)
        rhs = Support::TypeHelper.cast(ctx.builder, rhs_type, t, rhs)

        case @op
        when :add
          ctx.builder.add(lhs, rhs)
        when :sub
          ctx.builder.sub(lhs, rhs)
        when :mul
          ctx.builder.mul(lhs, rhs)
        when :div
          ctx.builder.sdiv(lhs, rhs)
        when :mod
          ctx.builder.srem(lhs, rhs)
        when :eq
          ctx.builder.icmp(:eq, lhs, rhs)
        when :ne
          ctx.builder.icmp(:ne, lhs, rhs)
        when :gt
          ctx.builder.icmp(:sgt, lhs, rhs)
        when :ge
          ctx.builder.icmp(:sge, lhs, rhs)
        when :lt
          ctx.builder.icmp(:slt, lhs, rhs)
        when :le
          ctx.builder.icmp(:sle, lhs, rhs)
        when :or, :lor
          ctx.builder.or(lhs, rhs)
        when :and, :land
          ctx.builder.and(lhs, rhs)
        when :xor
          ctx.builder.xor(lhs, rhs)
        when :lshift
          ctx.builder.shl(lhs, rhs)
        when :rshift
          ctx.builder.lshr(lhs, rhs)
        end
      end
    end
  end
end
