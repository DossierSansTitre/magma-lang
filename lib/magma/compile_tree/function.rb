require 'magma/compile_tree/node'
require 'magma/compile_tree/basic_block'

module Magma
  module CompileTree
    class Function < Node
      attr_reader :decl
      attr_reader :basic_blocks

      def initialize(decl)
        @decl = decl
        @basic_blocks = []
      end

      def type
        @decl.type
      end

      def name
        @decl.name
      end

      def visited(v)
        v.function(self)
      end

      def add_basic_block
        b = BasicBlock.new(@basic_blocks.size)
        @basic_blocks << b
        b
      end
    end
  end
end
