require 'magma/compile_tree/node'

module Magma
  module CompileTree
    class StatementReturn < Node
      def initialize(expr = nil)
        @expr = expr
      end

      def visited(v)
        v.statement_return(self)
      end
    end
  end
end
