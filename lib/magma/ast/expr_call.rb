require 'magma/ast/node'

module Magma
  module AST
    class ExprCall < Node
      def initialize(func_name)
        @func_name = func_name
      end

      def dump(indent = 0)
        super(indent, @func_name)
      end
    end
  end
end
