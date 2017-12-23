require 'magma/sema/expr_literal'

module Magma
  module Sema
    module Expr
      def self.literal(type, value)
        ExprLiteral.new(type, value)
      end
    end
  end
end
