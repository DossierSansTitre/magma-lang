require 'magma/compile_tree/node'

module Magma
  module CompileTree
    class Function < Node
      def initialize(decl)
        @decl = decl
      end

      def type
        @decl.type
      end
    end
  end
end
