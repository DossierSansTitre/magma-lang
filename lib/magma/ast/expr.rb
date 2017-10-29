require 'magma/ast/node'

module Magma
  module AST
    class Expr < Node
      def type(ctx)
        throw :not_implemented
      end
    end
  end
end
