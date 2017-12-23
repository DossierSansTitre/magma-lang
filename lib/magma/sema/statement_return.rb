require 'magma/sema/node'

module Magma
  module Sema
    class StatementReturn < Node
      def initialize(expr = nil)
        @expr = expr
      end

      def visited(v, *args)
        v.statement_return(self, *args)
      end
    end
  end
end
