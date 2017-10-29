require 'magma/ast/node'

module Magma
  module AST
    class StatementVariable < Node
      def initialize(name, type)
        @name = name
        @type = type
      end

      def dump(indent)
        super(indent, "#{@name}: #{@type}")
      end

      def generate(ctx)
        llvm_type = ctx.ast.types[@type].to_llvm
        loc = ctx.builder.alloca(llvm_type, "var_#{@name}")
        ctx.block.set_variable(@name, llvm_type, loc)
      end
    end
  end
end
