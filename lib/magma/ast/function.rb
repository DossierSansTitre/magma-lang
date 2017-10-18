require 'magma/ast/block'

module Magma
  module AST
    class Function < Node
      attr_writer :type
      attr_writer :block

      def initialize(name)
        @name = name
        @block = nil
        @type = "Void"
      end

      def children
        [@block].reject(&:nil?)
      end

      def dump(indent)
        super(indent, "#{@name} -> #{@type}")
      end

      def generate(mod)
        f = mod.functions.add(mangled_name, [], LLVM::Int)
        if @block
          b = f.basic_blocks.append
          @block.generate(b)
        end
        f
      end

      def main?
        @name == "main"
      end

      def mangled_name
        if main?
          "magma_main"
        else
          @name
        end
      end
    end
  end
end
