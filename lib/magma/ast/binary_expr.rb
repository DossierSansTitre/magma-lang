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

      def generate(mod, builder)
        lhs = @lhs.generate(mod, builder)
        rhs = @rhs.generate(mod, builder)

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
        end
      end
    end
  end
end
