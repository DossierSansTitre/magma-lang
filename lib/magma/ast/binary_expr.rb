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

      def generate(ast, block, builder)
        lhs = @lhs.generate(ast, block, builder)
        rhs = @rhs.generate(ast, block, builder)

        case @op
        when :tplus
          builder.add(lhs, rhs)
        when :tminus
          builder.sub(lhs, rhs)
        when :tmul
          builder.mul(lhs, rhs)
        when :tdiv
          builder.sdiv(lhs, rhs)
        when :tmod
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
