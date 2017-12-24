require 'magma/sema/node'

module Magma
  module Sema
    class ExprAssign < Node
      visited_as :expr_assign

      attr_reader :id
      attr_reader :type
      attr_reader :expr

      def initialize(id, type, expr)
        @id = id
        @type = type
        @expr = expr
      end
    end
  end
end
