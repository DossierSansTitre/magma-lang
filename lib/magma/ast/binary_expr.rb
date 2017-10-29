module Magma
  module AST
    class BinaryExpr < Node
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

      def generate(ast, block, builder)
        lhs = @lhs.generate(ast, block, builder)
        rhs = @rhs.generate(ast, block, builder)

        case @op
        when :add
          builder.add(lhs, rhs)
        when :sub
          builder.sub(lhs, rhs)
        when :mul
          builder.mul(lhs, rhs)
        when :div
          builder.sdiv(lhs, rhs)
        when :mod
          builder.srem(lhs, rhs)
        when :eq
          builder.icmp(:eq, lhs, rhs)
        when :ne
          builder.icmp(:ne, lhs, rhs)
        when :gt
          builder.icmp(:sgt, lhs, rhs)
        when :ge
          builder.icmp(:sge, lhs, rhs)
        when :lt
          builder.icmp(:slt, lhs, rhs)
        when :le
          builder.icmp(:sle, lhs, rhs)
        when :or, :lor
          builder.or(lhs, rhs)
        when :and, :land
          builder.and(lhs, rhs)
        when :xor
          builder.xor(lhs, rhs)
        when :lshift
          builder.shl(lhs, rhs)
        when :rshift
          builder.lshr(lhs, rhs)
        end
      end
    end
  end
end
