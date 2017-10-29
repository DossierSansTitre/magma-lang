require 'magma/ast/node'
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
      end

      def add_function(fun)
        @functions << fun
      end

      def function(name)
        @functions.select{|x| x.name == name}.first
      end

      def children
        @functions
      end

      def generate(ctx)
        ctx.ast = self
        ctx.module = LLVM::Module.new("Magma")
        @functions.each {|f| f.generate(ctx, false)}
        @functions.each {|f| f.generate(ctx, true)}
        nil
      end
    end
  end
end
