require 'magma/sema/node'

module Magma
  module Sema
    class ExprCast < Node
      visited_as :expr_cast

      attr_reader :type
      attr_reader :expr

      def initialize(type, expr)
        @type = type
        @expr = expr
      end
    end
  end
end
