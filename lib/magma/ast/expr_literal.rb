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

      def generate(ast, builder)
        if @type == "Int"
          LLVM::Int32.from_i(@value)
        else
          nil
        end
      end
    end
  end
end
