require 'magma/sema/node'

module Magma
  module Sema
    class ExprLiteral < Node
      def initialize(type, literal)
        @type = type
        @literal = literal
      end
    end
  end
end
