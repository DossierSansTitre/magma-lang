require 'magma/ast/node'

module Magma
  module AST
    class FunctionParam < Node
      attr_reader :name

      def initialize(name, type_str)
        @name = name
        @type_str = type_str
      end

      def dump(indent)
        super(indent, "#{@name}: #{@type_str}")
      end

      def type(ast)
        ast.types[@type_str]
      end
    end
  end
end