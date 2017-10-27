module Magma
  module AST
    class UnaryExpr < Node
      def initialize(op, val)
        @op = op
        @val = val
      end

      def generate(ast, block, builder)
        val = @val.generate(ast, block, builder)

        case @op
        when :tminus
          builder.neg(val)
        when :tbang
          builder.not(val)
        end
      end
    end
  end
end
