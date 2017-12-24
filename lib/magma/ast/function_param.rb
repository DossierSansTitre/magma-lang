require 'magma/ast/node'

module Magma
  module AST
    class FunctionParam < Node
      attr_reader :name
      attr_reader :type

      def initialize(name, type)
        @name = name
        @type = type
      end

      def dump(indent)
        super(indent, "#{@name}: #{@type}")
      end
    end
  end
end
