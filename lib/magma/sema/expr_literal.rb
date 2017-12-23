require 'magma/sema/node'

module Magma
  module Sema
    class ExprLiteral < Node
      def initialize(type, literal)
        @type = type
        @literal = literal
      end

      def visited(v, *args)
        v.expr_literal(*args)
      end
    end
  end
end
