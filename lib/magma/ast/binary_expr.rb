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
        when :teq
          builder.icmp(:eq, lhs, rhs)
        when :tne
          builder.icmp(:ne, lhs, rhs)
        when :tg
          builder.icmp(:sgt, lhs, rhs)
        when :tge
          builder.icmp(:sge, lhs, rhs)
        when :tl
          builder.icmp(:slt, lhs, rhs)
        when :tle
          builder.icmp(:sle, lhs, rhs)
        when :tor
          builder.or(lhs, rhs)
        when :tand
          builder.and(lhs, rhs)
        end
      end
    end
  end
end
