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

      def generate(ast, block, builder)
        t = ast.types[@type]
        t_llvm = t.to_llvm
        t_llvm.from_i(@value)
      end
    end
  end
end
