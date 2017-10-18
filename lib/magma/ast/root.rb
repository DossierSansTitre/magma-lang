require 'magma/ast/function'
require 'llvm/linker'

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

      def generate(mod, generate_body)
        @functions.each {|f| f.generate(mod, generate_body)}
      end
    end
  end
end
