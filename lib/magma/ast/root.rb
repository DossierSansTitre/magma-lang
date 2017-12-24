require 'magma/ast/node'

module Magma
  module AST
    class Root < Node
      attr_reader :types
      attr_reader :module
      attr_reader :functions

      def initialize
        @functions = []
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

      def visited(v, *args)
        v.root(self, *args)
      end
    end
  end
end
