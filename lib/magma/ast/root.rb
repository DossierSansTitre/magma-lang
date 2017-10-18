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

      def generate
        ::LLVM::Module.new("magma").tap do |mod|
          @functions.each {|f| f.generate(mod)}
        end
      end
    end
  end
end
