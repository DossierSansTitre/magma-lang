require 'magma/sema/node'
require 'magma/sema/basic_block'

module Magma
  module Sema
    class Function < Node
      attr_reader :decl
      attr_reader :basic_blocks
      attr_reader :vars

      def initialize(decl)
        @decl = decl
        @basic_blocks = []
        @vars = []
      end

      def type
        @decl.type
      end

      def name
        @decl.name
      end

      def mangled_name
        @decl.mangled_name
      end

      def visited(v)
        v.function(self)
      end

      def add_basic_block
        b = BasicBlock.new(@basic_blocks.size)
        @basic_blocks << b
        b
      end

      def add_var(type)
        id = @vars.size
        @vars << type
        id
      end
    end
  end
end
