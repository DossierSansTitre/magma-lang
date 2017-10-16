require 'magma/ast/function'

module Magma
  module AST
    class Root < Node
      def initialize
        @functions = []
      end

      def add_function(fun)
        @functions << fun
      end

      def children
        @functions
      end
    end
  end
end
