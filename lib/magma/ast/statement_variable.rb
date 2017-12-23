require 'magma/ast/node'

module Magma
  module AST
    class StatementVariable < Node
      visited_as :statement_variable

      attr_reader :name
      attr_reader :type

      def initialize(name, type)
        @name = name
        @type = type
      end

      def dump(indent)
        super(indent, "#{@name}: #{@type}")
      end

      def generate(ctx)
        type = ctx.ast.types[@type]
        loc = ctx.builder.alloca(type.to_llvm, "var_#{@name}")
        ctx.block.set_variable(@name, type, loc)
      end
    end
  end
end
