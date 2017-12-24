require 'magma/sema/node'

module Magma
  module Sema
    class ExprVariable < Node
      visited_as :expr_variable

      attr_reader :id
      attr_reader :type

      def initialize(id, type)
        @id = id
        @type = type
      end
    end
  end
end
