require 'magma/ast/block'

module Magma
  module AST
    class Function < Node
      def initialize(name, block)
        @name = name
        @block = block
      end

      def children
        [@block]
      end

      def dump(indent)
        super(indent, @name)
      end
    end
  end
end
