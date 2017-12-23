require 'magma/sema/node'

module Magma
  module Sema
    class ExprCall < Node
      visited_as :expr_call

      attr_reader :decl
      attr_reader :exprs

      def initialize(decl, exprs)
        @decl = decl
        @exprs = exprs
      end
    end
  end
end
