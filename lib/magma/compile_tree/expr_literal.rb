require 'magma/compile_tree/node'

module Magma
  module CompileTree
    class ExprLiteral < Node
      def initialize(type, literal)
        @type = type
        @literal = literal
      end
    end
  end
end
