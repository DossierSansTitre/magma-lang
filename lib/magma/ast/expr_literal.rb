require 'magma/ast/node'

module Magma
  module AST
    class ExprLiteral < Node
      def initialize(type, value)
        @type = type
        @value = value
      end

      def dump(indent = 0)
        super(indent, "#{@value}:#{@type}")
      end
    end
  end
end
