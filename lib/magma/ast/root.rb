require 'magma/ast/function'
require 'magma/ast/type_system'
require 'llvm/linker'

module Magma
  module AST
    class Root < Node
      attr_reader :types
      attr_reader :module

      def initialize
        @functions = []
        @types = TypeSystem.new
        @module = nil
      end

      def add_function(fun)
        @functions << fun
      end

      def children
        @functions
      end

      def generate
        @module = LLVM::Module.new("Magma")
        @functions.each {|f| f.generate(self, false)}
        @functions.each {|f| f.generate(self, true)}
        @module
      end
    end
  end
end
