require 'magma/sema/node'

module Magma
  module Sema
    class ExprAssign < Node
      visited_as :expr_assign

      attr_reader :id
      attr_reader :expr

      def initialize(id, expr)
        @id = id
        @expr = expr
      end
    end
  end
end
