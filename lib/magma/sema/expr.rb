require 'magma/sema/expr_literal'
require 'magma/sema/expr_binary'
require 'magma/sema/expr_cast'

module Magma
  module Sema
    module Expr
      def self.binary(op, lhs, rhs)
        ExprBinary.new(op, lhs, rhs)
      end

      def self.literal(type, value)
        ExprLiteral.new(type, value)
      end

      def self.cast(type, expr)
        e_type = expr.type
        if type == e_type
          expr
        else
          ExprCast.new(type, expr)
        end
      end
    end
  end
end
