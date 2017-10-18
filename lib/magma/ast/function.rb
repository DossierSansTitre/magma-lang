require 'magma/ast/block'
require 'magma/support/name_mangler'

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

      def generate(mod, generate_body)
        f = nil
        if generate_body
          f = mod.functions[mangled_name]
        else
          f = mod.functions.add(mangled_name, [], LLVM::Int)
        end
        if @block && generate_body
          b = f.basic_blocks.append
          @block.generate(mod, b)
        end
        f
      end

      def mangled_name
        Support::NameMangler.function(@name)
      end
    end
  end
end
