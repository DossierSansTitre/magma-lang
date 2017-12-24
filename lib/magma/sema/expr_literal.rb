require 'magma/sema/node'

module Magma
  module Sema
    class ExprLiteral < Node
      attr_reader :type
      attr_reader :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def visited(v, *args)
        v.expr_literal(self, *args)
      end
    end
  end
end
