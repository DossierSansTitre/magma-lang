require 'magma/sema/node'

module Magma
  module Sema
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
